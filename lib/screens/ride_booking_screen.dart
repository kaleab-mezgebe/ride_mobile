import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nyat_ride_system/core/constants/flutter_maps/secrets.dart';
import '../app.dart';
import '../models/ride_type.dart';
import '../core/services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/map_widget.dart';
import '../widgets/ride_type_selector.dart';
import '../widgets/location_row.dart';
import '../widgets/drawer_menu.dart';
import 'address_input_screen.dart';
import 'notifications.dart';
import 'profile.dart';
import 'ride_history.dart';
import 'phone_register_screen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({Key? key}) : super(key: key);

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;

  LatLng? _currentLocation;
  LatLng? _pickupPoint;
  LatLng? _dropoffPoint;

  String? _pickupName;
  String? _dropoffName;
  String _selectedRideType = "";
  RideType? selectedRide;

  List<RideType> rideTypes = [];
  List<LatLng> _routePolyline = [];
  double? _routeDistanceKm;
  double? _routeDurationMin;
  double? _totalPrice;

  final PolylinePoints _polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _requestLocation();
    _loadRideTypes();
  }

  Future<void> _requestLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  Future<void> _loadRideTypes() async {
    final api = ApiService();
    final types = await api.getAvailableCars();

    setState(() {
      rideTypes = types.map((e) => RideType.fromJson(e)).toList();
      if (rideTypes.isNotEmpty) {
        _selectedRideType = rideTypes[0].type;
        selectedRide = rideTypes[0];
      }
    });
  }

  Future<void> _drawRoute() async {
    if (_pickupPoint == null || _dropoffPoint == null) return;

    // Use Google Directions API
    final String apiKey = Secrets.API_KEY;
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_pickupPoint!.latitude},${_pickupPoint!.longitude}&destination=${_dropoffPoint!.latitude},${_dropoffPoint!.longitude}&alternatives=true&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isEmpty) return;

      final points = data['routes'][0]['overview_polyline']['points'];
      List<PointLatLng> result = _polylinePoints.decodePolyline(points);

      setState(() {
        _routePolyline =
            result.map((e) => LatLng(e.latitude, e.longitude)).toList();

        _routeDistanceKm =
            (data['routes'][0]['legs'][0]['distance']['value'] as num) / 1000;
        _routeDurationMin =
            (data['routes'][0]['legs'][0]['duration']['value'] as num) / 60;

        if (selectedRide != null && _routeDistanceKm != null) {
          _totalPrice =
              selectedRide!.basePrice +
              (_routeDistanceKm! * selectedRide!.perKmPrice);
        }
      });

      // Fit map bounds
      if (_routePolyline.isNotEmpty && _mapController != null) {
        LatLngBounds bounds = _getBounds(_routePolyline);
        _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (var p in points) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NyatApp.isDarkMode,
      builder: (_, darkMode, __) {
        final theme = darkMode ? ThemeData.dark() : AppTheme.light();
        final primaryColor = theme.colorScheme.primary;

        final isActive =
            _pickupName != null &&
            _dropoffName != null &&
            _selectedRideType.isNotEmpty;

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          drawer: DrawerMenu(
            primaryColor: primaryColor,
            darkMode: darkMode,
            onRideHistory: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RideHistoryScreen()),
              );
            },
            onNotifications: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsScreen()),
              );
            },
            onProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(token: "mock_token"),
                ),
              );
            },
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PhoneRegisterScreen()),
              );
            },
            onDarkModeToggle: (v) => NyatApp.isDarkMode.value = v,
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 2,
            leading: Container(
              margin: const EdgeInsets.all(8), // spacing from edges
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),

          body: Stack(
            children: [
              Positioned.fill(
                child: MapWidget(
                  mapController: _mapController,
                  currentLocation: _currentLocation,
                  pickupPoint: _pickupPoint,
                  dropoffPoint: _dropoffPoint,
                  routePolyline: _routePolyline,
                  primaryColor: primaryColor,
                  routeDistanceKm: _routeDistanceKm,
                  routeDurationMin: _routeDurationMin,
                  onMapCreated: (controller) => _mapController = controller,
                ),
              ),
              _buildBottomPanel(primaryColor, darkMode, isActive),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(Color primaryColor, bool darkMode, bool isActive) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          decoration: BoxDecoration(
            color: darkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pickup Location
              LocationRow(
                label: "Pickup",
                location: _pickupName,
                isPickup: true,
                primaryColor: primaryColor,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoogleAddressInputScreen(places: {}),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _pickupName = result['name'];
                      _pickupPoint = result['latLng'];
                    });
                    await _drawRoute();
                  }
                },
              ),
              const SizedBox(height: 12),

              // Dropoff Location
              LocationRow(
                label: "Dropoff",
                location: _dropoffName,
                isPickup: false,
                primaryColor: primaryColor,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoogleAddressInputScreen(places: {}),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _dropoffName = result['name'];
                      _dropoffPoint = result['latLng'];
                    });
                    await _drawRoute();
                  }
                },
              ),
              const SizedBox(height: 20),

              // Ride Type Selector
              RideTypeSelector(
                rideTypes: rideTypes,
                selectedType: _selectedRideType,
                routeDistanceKm: _routeDistanceKm,
                primaryColor: primaryColor,
                onSelect: (ride, price) {
                  setState(() {
                    _selectedRideType = ride.type;
                    selectedRide = ride;
                    if (_routeDistanceKm != null) {
                      _totalPrice = price;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: BorderSide(color: primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor:
                            darkMode ? Colors.grey[850] : Colors.white,
                        shadowColor: Colors.black.withOpacity(0.1),
                        elevation: 3,
                      ),
                      onPressed: () {
                        setState(() {
                          _pickupPoint = null;
                          _dropoffPoint = null;
                          _pickupName = null;
                          _dropoffName = null;
                          _routePolyline.clear();
                          _routeDistanceKm = null;
                          _routeDurationMin = null;
                          _totalPrice = null;
                        });
                      },
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor:
                            isActive ? primaryColor : Colors.grey.shade400,
                        shadowColor: Colors.black.withOpacity(0.25),
                        elevation: 6,
                      ),
                      onPressed:
                          isActive
                              ? () async {
                                if (_pickupPoint != null &&
                                    _dropoffPoint != null &&
                                    selectedRide != null) {
                                  final api = ApiService();
                                  await api.postRideOrder(
                                    token: "mock_token",
                                    carType: _selectedRideType,
                                    pickup: _pickupPoint!,
                                    dropoff: _dropoffPoint!,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Ordered $_selectedRideType from $_pickupName to $_dropoffName",
                                      ),
                                      backgroundColor: primaryColor,
                                    ),
                                  );
                                }
                              }
                              : null,
                      child: const Text(
                        "Order Ride",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
