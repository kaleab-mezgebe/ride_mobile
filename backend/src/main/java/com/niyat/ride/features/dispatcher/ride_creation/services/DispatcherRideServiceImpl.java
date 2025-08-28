package com.niyat.ride.features.dispatcher.ride_creation.services;

import com.niyat.ride.enums.RideStatus;
import com.niyat.ride.features.admin.pricing_management.services.BasePriceService;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.DispatcherRideRequestDTO;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.DispatcherRideResponseDTO;
import com.niyat.ride.features.dispatcher.ride_creation.dtos.LocationDTO;
import com.niyat.ride.customer.models.Customer;
import com.niyat.ride.ride.models.RideRequest;
import com.niyat.ride.vehicle.VehicleType;
import com.niyat.ride.driver.repositories.DriverRepository;
import com.niyat.ride.ride.repositories.RideRequestRepository;
import com.niyat.ride.features.admin.vehicle_type_management.repositories.VehicleTypeRepository;
import com.niyat.ride.shared.dtos.NearbyDriverDTO;
import com.niyat.ride.shared.services.DriverDiscoveryService;
import com.niyat.ride.shared.services.PriceCalculatorService;
import com.niyat.ride.shared.utils.PaginationUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DispatcherRideServiceImpl implements DispatcherRideService {

    private final RideRequestRepository rideRequestRepository;
    private final DriverRepository driverRepository;
    private final VehicleTypeRepository vehicleTypeRepository;
    private final PriceCalculatorService priceCalculatorService;
    private final CustomerOrchestrationService customerOrchestrationService;
    private final LocationValidationService locationValidationService;
    private final DriverDiscoveryService driverDiscoveryService;
    private final BasePriceService basePriceService;

    @Override
    @Transactional
    public DispatcherRideResponseDTO createRide(DispatcherRideRequestDTO request, Long dispatcherId) {
        log.info("Creating new ride for dispatcher: {}", dispatcherId);
        
        // Validate locations
        locationValidationService.validateLocationInfo(request.getPickupLocation());
        locationValidationService.validateLocationInfo(request.getDropoffLocation());
        
        // Find or create customer
        Customer customer = customerOrchestrationService.findOrCreateCustomer(request.getCustomerInfo());

        // Calculate distance if not provided
        Double distance = request.getEstimatedDistance();
        if (distance == null) {
            distance = locationValidationService.calculateDistance(
                    request.getPickupLocation().getLatitude(),
                    request.getPickupLocation().getLongitude(),
                    request.getDropoffLocation().getLatitude(),
                    request.getDropoffLocation().getLongitude()
            );
        }

        // Create ride request (without pricing - pricing happens at driver assignment)
        RideRequest rideRequest = new RideRequest();
        rideRequest.setPassengerId(customer.getId());
        rideRequest.setDispatcherId(request.getDispatcherId());
        rideRequest.setVehicleTypeId(request.getVehicleTypePreference());
        
        // Set pickup location
        rideRequest.setPickupLatitude(request.getPickupLocation().getLatitude());
        rideRequest.setPickupLongitude(request.getPickupLocation().getLongitude());
        rideRequest.setPickupAddress(request.getPickupLocation().getAddress());
        
        // Set dropoff location
        rideRequest.setDropoffLatitude(request.getDropoffLocation().getLatitude());
        rideRequest.setDropoffLongitude(request.getDropoffLocation().getLongitude());
        rideRequest.setDropoffAddress(request.getDropoffLocation().getAddress());
        
        rideRequest.setDistanceKm(distance);
        rideRequest.setEstimatedDurationMin(request.getEstimatedDuration());
        rideRequest.setStatus(RideStatus.REQUESTED);
        rideRequest.setNotes(request.getNotes());
        rideRequest.setRequestedAt(LocalDateTime.now());

        RideRequest savedRide = rideRequestRepository.save(rideRequest);
        log.info("Created ride request with ID: {}", savedRide.getId());

        // Find nearby drivers
        List<NearbyDriverDTO> nearbyDrivers = driverDiscoveryService.findNearbyDrivers(
                request.getPickupLocation().getLatitude(),
                request.getPickupLocation().getLongitude(),
                5.0, // 5km radius
                request.getVehicleTypePreference(),
                10 // max 10 drivers
        );

        return mapToResponseDTO(savedRide, customer, nearbyDrivers);
    }

    @Override
    @Transactional
    public DispatcherRideResponseDTO assignDriverToRide(Long rideId, Long driverId) {
        log.info("Assigning driver {} to ride {}", driverId, rideId);
        
        RideRequest ride = rideRequestRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found with id: " + rideId));
        
        // Validate driver exists and is available
        if (!driverDiscoveryService.isDriverAvailable(driverId)) {
            throw new RuntimeException("Driver is not available for new rides");
        }
        
        // Calculate pricing at assignment time: base price + (vehicle type price per KM * distance)
        BigDecimal basePrice = basePriceService.getCurrentBasePriceAmount();
        BigDecimal totalPrice = basePrice;
        
        if (ride.getVehicleTypeId() != null) {
            VehicleType vehicleType = vehicleTypeRepository.findById(ride.getVehicleTypeId())
                    .orElseThrow(() -> new RuntimeException("Vehicle type not found"));
            
            BigDecimal distancePrice = vehicleType.getPricePerKm()
                    .multiply(BigDecimal.valueOf(ride.getDistanceKm()));
            totalPrice = basePrice.add(distancePrice);
        }
        
        ride.setDriverId(driverId);
        ride.setEstimatedCost(totalPrice);
        ride.setStatus(RideStatus.ACCEPTED);
        ride.setAcceptedAt(LocalDateTime.now());
        
        RideRequest updatedRide = rideRequestRepository.save(ride);
        log.info("Driver assigned successfully. Total price: {}", totalPrice);
        
        Customer customer = customerOrchestrationService.findCustomerByPhoneNumber(
                ride.getPassengerId().toString()); // This needs to be fixed - should get customer by ID
        
        return mapToResponseDTO(updatedRide, customer, List.of());
    }

    @Override
    public Page<DispatcherRideResponseDTO> getDispatcherRides(Long dispatcherId, Integer page, Integer size, 
                                                             String sortBy, String sortDirection) {
        Pageable pageable = PaginationUtil.createPageable(page, size, sortBy, sortDirection);
        Page<RideRequest> ridesPage = rideRequestRepository.findByDispatcherId(dispatcherId, pageable);
        
        return ridesPage.map(ride -> {
            // Get customer info - this needs a proper customer repository method
            Customer customer = null; // TODO: Fix this by adding CustomerRepository back
            return mapToResponseDTO(ride, customer, List.of());
        });
    }

    @Override
    public DispatcherRideResponseDTO getRideById(Long rideId) {
        RideRequest ride = rideRequestRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found with id: " + rideId));
        
        // Get customer info - this needs a proper customer repository method  
        Customer customer = null; // TODO: Fix this by adding CustomerRepository back
        return mapToResponseDTO(ride, customer, List.of());
    }

    private DispatcherRideResponseDTO mapToResponseDTO(RideRequest ride, Customer customer, 
                                                      List<NearbyDriverDTO> nearbyDrivers) {
        DispatcherRideResponseDTO dto = new DispatcherRideResponseDTO();
        dto.setId(ride.getId());
        dto.setCustomerId(ride.getPassengerId());
        dto.setDriverId(ride.getDriverId());
        dto.setVehicleTypeId(ride.getVehicleTypeId());
        dto.setStatus(ride.getStatus());
        dto.setEstimatedCost(ride.getEstimatedCost());
        dto.setFinalCost(ride.getFinalCost());
        dto.setDistanceKm(ride.getDistanceKm());
        dto.setEstimatedDurationMin(ride.getEstimatedDurationMin());
        dto.setRequestedAt(ride.getRequestedAt());
        dto.setAcceptedAt(ride.getAcceptedAt());
        dto.setStartedAt(ride.getStartedAt());
        dto.setCompletedAt(ride.getCompletedAt());
        dto.setCancelledAt(ride.getCancelledAt());
        dto.setCancellationReason(ride.getCancellationReason());
        dto.setNotes(ride.getNotes());
        dto.setDispatcherId(ride.getDispatcherId());
        dto.setNearbyDrivers(nearbyDrivers);

        // Set customer info
        if (customer != null) {
            dto.setCustomerName(customer.getFirstName() + " " + customer.getLastName());
            dto.setCustomerPhoneNumber(customer.getPhoneNumber());
        }

        // Set location DTOs
        LocationDTO pickupLocation = new LocationDTO();
        pickupLocation.setLatitude(ride.getPickupLatitude());
        pickupLocation.setLongitude(ride.getPickupLongitude());
        pickupLocation.setAddress(ride.getPickupAddress());
        dto.setPickupLocation(pickupLocation);

        LocationDTO dropoffLocation = new LocationDTO();
        dropoffLocation.setLatitude(ride.getDropoffLatitude());
        dropoffLocation.setLongitude(ride.getDropoffLongitude());
        dropoffLocation.setAddress(ride.getDropoffAddress());
        dto.setDropoffLocation(dropoffLocation);

        // Set vehicle type name if available
        if (ride.getVehicleTypeId() != null) {
            vehicleTypeRepository.findById(ride.getVehicleTypeId())
                    .ifPresent(vehicleType -> dto.setVehicleTypeName(vehicleType.getName()));
        }

        return dto;
    }

    // TODO: Add missing repository methods to RideRequestRepository
    // - findByDispatcherId(Long dispatcherId, Pageable pageable)
    // TODO: Add CustomerRepository back to get customer details properly
}
