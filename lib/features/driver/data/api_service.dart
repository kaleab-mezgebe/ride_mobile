// import 'dart:async';
// import 'dart:math';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:nyat_ride_system/features/auth/domain/models/user.dart';
// import 'package:nyat_ride_system/features/driver/domain/models/driver.dart';

// class ApiService {
//   ApiService._privateConstructor();
//   static final ApiService _instance = ApiService._privateConstructor();
//   factory ApiService() => _instance;

//   // ----------------------
//   // Mock storage
//   // ----------------------
//   final Map<String, String> _otpStorage = {};
//   String? _token;
//   final Map<String, UserModel> _users = {};

//   // ----------------------
//   // Mock drivers
//   // ----------------------
//   final List<Map<String, dynamic>> _drivers = [
//     {
//       "driverId": "D001",
//       "firstName": "Abel",
//       "lastName": "Tesfaye",
//       "gender": "Male",
//       "picture": "https://i.pravatar.cc/150?img=3",
//       "carPicture":
//           "https://cdn.pixabay.com/photo/2016/03/31/19/56/car-1299201_960_720.png",
//       "plateNumber": "ETH-1234",
//       "latLng": LatLng(9.03, 38.74),
//       "phone": "+251912345678",
//     },
//     {
//       "driverId": "D002",
//       "firstName": "Sara",
//       "lastName": "Mekonnen",
//       "gender": "Female",
//       "picture": "https://i.pravatar.cc/150?img=5",
//       "carPicture":
//           "https://cdn.pixabay.com/photo/2016/03/31/19/56/car-1299201_960_720.png",
//       "plateNumber": "ETH-5678",
//       "latLng": LatLng(9.04, 38.75),
//       "phone": "+251911234567",
//     },
//   ];

//   // ----------------------
//   // Get all available drivers
//   // ----------------------
//   List<Map<String, dynamic>> getAvailableDrivers() {
//     return _drivers;
//   }

//   // ----------------------
//   // Track driver location toward pickup
//   // ----------------------
//   Stream<LatLng> trackDriver(String driverId, LatLng pickup) async* {
//     Map<String, dynamic>? driver;
//     try {
//       driver = _drivers.firstWhere((d) => d['driverId'] == driverId);
//     } catch (e) {
//       return;
//     }

//     LatLng loc = driver['latLng'];
//     while (true) {
//       await Future.delayed(const Duration(seconds: 1));

//       final latDiff = pickup.latitude - loc.latitude;
//       final lngDiff = pickup.longitude - loc.longitude;
//       loc = LatLng(
//         loc.latitude + latDiff * 0.02,
//         loc.longitude + lngDiff * 0.02,
//       );

//       driver['latLng'] = loc;
//       yield loc;
//     }
//   }

//   // ----------------------
//   // Get driver info by ID
//   // ----------------------
//   DriverModel getDriverById(String driverId) {
//     final map = _drivers.firstWhere((d) => d['driverId'] == driverId);
//     return DriverModel.fromMap(map);
//   }
// }
