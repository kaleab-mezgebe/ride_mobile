package com.niyat.ride.services.serviceImpl;

import com.niyat.ride.dtos.DispatcherResponseDTO;
import com.niyat.ride.dtos.DispatcherSignupDTO;
import com.niyat.ride.dtos.DispatcherUpdateDTO;
import com.niyat.ride.enums.Role;
import com.niyat.ride.mappers.DispatcherMapper;
import com.niyat.ride.models.Dispatcher;
import com.niyat.ride.repositories.DispatcherRepository;
import com.niyat.ride.services.DispatcherService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class DispatcherServiceImpl implements DispatcherService {

    private final DispatcherRepository dispatcherRepository;
    private final DispatcherMapper dispatcherMapper;

    @Override
    @Transactional
    public DispatcherResponseDTO signUpDispatcher(DispatcherSignupDTO dispatcherSignupDTO) {
        dispatcherRepository.findByPhoneNumber(dispatcherSignupDTO.getPhoneNumber())
                .ifPresent(d -> {
                    throw new RuntimeException(
                            "Dispatcher with phone number " + d.getPhoneNumber() + " already exists");
                });

        Dispatcher dispatcher = dispatcherMapper.toEntity(dispatcherSignupDTO);
        dispatcher.setRole(Role.DISPATCHER);
        dispatcher.setPhoneNumber(dispatcherSignupDTO.getPhoneNumber());
        dispatcher.setAssignedRegion(dispatcherSignupDTO.getAssignedRegion());
        dispatcher.setCreatedAt(LocalDateTime.now());
        dispatcher.setUpdatedAt(LocalDateTime.now());
        Dispatcher savedDispatcher = dispatcherRepository.save(dispatcher);

        return dispatcherMapper.toResponseDTO(savedDispatcher);
    }

    @Override
    @Transactional
    public DispatcherResponseDTO updateDispatcher(Long dispatcherId, DispatcherUpdateDTO updateDTO) {
        Dispatcher dispatcher = dispatcherRepository.findById(dispatcherId)
                .orElseThrow(() -> new RuntimeException("Dispatcher not found with id: " + dispatcherId));

        dispatcher.setName(updateDTO.getFirstName());
        dispatcher.setEmail(updateDTO.getEmail());
        if (updateDTO.getAssignedRegion() != null) {
            dispatcher.setAssignedRegion(updateDTO.getAssignedRegion());
        }
        dispatcher.setUpdatedAt(LocalDateTime.now());

        Dispatcher updatedDispatcher = dispatcherRepository.save(dispatcher);
        return dispatcherMapper.toResponseDTO(updatedDispatcher);
    }
}