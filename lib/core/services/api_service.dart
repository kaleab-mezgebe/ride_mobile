import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../features/auth/domain/models/user.dart';
import '../../features/driver/domain/models/driver.dart';

class ApiService {
  // ----------------------
  // Singleton setup
  // ----------------------
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() => _instance;

  // ----------------------
  // Mock storage
  // ----------------------
  final Map<String, String> _otpStorage = {}; // phone -> otp
  final Map<String, UserModel> _users = {}; // phone -> user

  // ----------------------
  // Mock cars for ride booking
  // ----------------------
  final List<Map<String, dynamic>> _cars = [
    {
      "type": "Vitz",
      "icon": "🚗",
      "latLng": LatLng(9.03, 38.74),
      "perKmPrice": 10.0,
      "basePrice": 50.0,
    },
    {
      "type": "Hyundai",
      "icon": "🚙",
      "latLng": LatLng(9.04, 38.75),
      "perKmPrice": 12.0,
      "basePrice": 60.0,
    },
    {
      "type": "Taxi",
      "icon": "🚕",
      "latLng": LatLng(9.02, 38.73),
      "perKmPrice": 15.0,
      "basePrice": 80.0,
    },
  ];

  // ----------------------
  // Mock drivers
  // ----------------------
  final List<Map<String, dynamic>> _drivers = [
    {
      "driverId": "D001",
      "firstName": "Abel",
      "lastName": "Tesfaye",
      "gender": "Male",
      "phoneNumber": "+251911000111",
      "picture": "https://i.pravatar.cc/150?img=3",
      "carPicture":
          "https://cdn.pixabay.com/photo/2016/03/31/19/56/car-1299201_960_720.png",
      "plateNumber": "ETH-1234",
      "latLng": LatLng(9.03, 38.74),
    },
    {
      "driverId": "D002",
      "firstName": "Sara",
      "lastName": "Mekonnen",
      "gender": "Female",
      "phoneNumber": "+251911000222",
      "picture": "https://i.pravatar.cc/150?img=5",
      "carPicture":
          "https://cdn.pixabay.com/photo/2016/03/31/19/56/car-1299201_960_720.png",
      "plateNumber": "ETH-5678",
      "latLng": LatLng(9.04, 38.75),
    },
  ];

  //----------------------
  //SEND OTP
  // ----------------------
  Future<String> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    final otp = "123456";
    _otpStorage[phoneNumber] = otp;
    return "OTP sent to $phoneNumber";
  }

  // ----------------------
  // VERIFY OTP
  // ----------------------
  Future<Map<String, dynamic>?> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_otpStorage[phoneNumber] == otp) {
      _otpStorage.remove(phoneNumber);
      final userExists = _users.containsKey(phoneNumber);
      return {
        "userExists": userExists,
        "user":
            userExists
                ? _users[phoneNumber]!.toJson()
                : {
                  "phone": phoneNumber,
                  "firstName": "",
                  "lastName": "",
                  "email": "",
                },
      };
    }
    return null;
  }

  // ----------------------
  // RESEND OTP
  // ----------------------
  Future<String> resendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    final otp = "123456";
    _otpStorage[phoneNumber] = otp;
    return "OTP resent to $phoneNumber";
  }

  // ----------------------
  // GET USER PROFILE
  // ----------------------

  // ----------------------
  // UPDATE PROFILE
  // ----------------------
  Future<UserModel?> updateProfile(UserModel updatedUser, int? id) async {
    await Future.delayed(const Duration(seconds: 1));
    _users[updatedUser.phone] = updatedUser;
    return updatedUser;
  }

  // // ----------------------
  // // Base URL of your backend
  // // ----------------------
  // final String baseUrl = "https://niyat-ride-1-q0om.onrender.com/api";

  // Future<String> sendOtp(String phone) async {
  //   final url = Uri.parse("$baseUrl/customers/request-otp");

  //   try {
  //     // ✅ Print phone number before sending
  //     print("Sending OTP to phone number: $phone");

  //     final response = await http
  //         .post(url, body: {'phoneNumber': phone})
  //         .timeout(const Duration(seconds: 50));

  //     print("Status: ${response.statusCode}");
  //     print("Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       return response.body.trim();
  //     } else {
  //       throw Exception("Failed to send OTP: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Error sending OTP: $e");
  //     rethrow;
  //   }
  // }

  // // Verify OTP
  // Future<Map<String, dynamic>?> verifyOtp(
  //   String phoneNumber,
  //   String otp,
  // ) async {
  //   final url = Uri.parse("$baseUrl/customers/verify-otp");

  //   try {
  //     final response = await http
  //         .post(url, body: {'phoneNumber': phoneNumber, 'otp': otp})
  //         .timeout(const Duration(seconds: 15));

  //     print("Response status: ${response.statusCode}");
  //     print("Response body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       return response.body.isNotEmpty
  //           ? Map<String, dynamic>.from(
  //             jsonDecode(response.body) as Map<String, dynamic>,
  //           )
  //           : null;
  //     } else {
  //       print("Failed to verify OTP: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error verifying OTP: $e");
  //     return null;
  //   }
  // }

  // // 🔹 RESEND OTP
  // Future<String> resendOtp(String phoneNumber) async {
  //   final url = Uri.parse("$baseUrl/resend-otp");
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"phone": phoneNumber}),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data["message"] ?? "OTP resent";
  //   } else {
  //     throw Exception("Failed to resend OTP: ${response.body}");
  //   }
  // }

  // // Update profile
  // Future<UserModel?> updateProfile(
  //   UserModel updatedUser,
  //   int customerId,
  // ) async {
  //   final url = Uri.parse(
  //     "https://niyat-ride-1-q0om.onrender.com/api/customers/updateCustomer/$customerId",
  //   );

  //   try {
  //     final response = await http.patch(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "firstName": updatedUser.firstName,
  //         "lastName": updatedUser.lastName,
  //         "email": updatedUser.email,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return UserModel.fromJson({
  //         'id': data['id'],
  //         'phone': data['phoneNumber'],
  //         'firstName': data['firstName'],
  //         'lastName': data['lastName'],
  //         'email': data['email'],
  //       });
  //     } else {
  //       print("Failed to update profile: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error updating profile: $e");
  //     return null;
  //   }
  // }

  // Future<UserModel?> updateProfile(
  //   UserModel updatedUser,
  //   int customerId,
  // ) async {
  //   final url = Uri.parse("$baseUrl/customers/updateCustomer/$customerId");

  //   try {
  //     final response = await http.patch(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(updatedUser.toJson()),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return UserModel.fromJson({
  //         'id': data['id'],
  //         'phoneNumber': data['phoneNumber'],
  //         'firstName': data['firstName'],
  //         'lastName': data['lastName'],
  //         'email': data['email'],
  //       });
  //     } else {
  //       print("Failed to update profile: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error updating profile: $e");
  //     return null;
  //   }
  // }

  // ----------------------
  // GET AVAILABLE CARS
  // ----------------------
  Future<List<Map<String, dynamic>>> getAvailableCars() async {
    await Future.delayed(const Duration(seconds: 1));
    return _cars;
  }

  // ----------------------
  // POST RIDE ORDER
  // ----------------------
  double _calculateDistanceKm(LatLng start, LatLng end) {
    const R = 6371;
    final lat1 = start.latitude * (pi / 180);
    final lat2 = end.latitude * (pi / 180);
    final dLat = (end.latitude - start.latitude) * (pi / 180);
    final dLon = (end.longitude - start.longitude) * (pi / 180);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<Map<String, dynamic>> postRideOrder({
    required LatLng pickup,
    required LatLng dropoff,
    required String carType,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final car = _cars.firstWhere((c) => c["type"] == carType);
    final distance = _calculateDistanceKm(pickup, dropoff);
    final price = car["basePrice"] + (car["perKmPrice"] * distance);

    final driver = _drivers[Random().nextInt(_drivers.length)];
    driver['latLng'] = driver['latLng'];

    return {
      "rideId": DateTime.now().millisecondsSinceEpoch.toString(),
      "carType": carType,
      "pickup": pickup,
      "dropoff": dropoff,
      "distanceKm": distance,
      "price": price,
      "status": "pending",
      "driver": driver,
    };
  }

  // ----------------------
  // DRIVER LOCATION
  // ----------------------
  Future<LatLng?> getDriverLocation(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final driver = _drivers.firstWhere((d) => d['driverId'] == driverId);
      return driver['latLng'];
    } catch (e) {
      return null;
    }
  }

  Stream<LatLng> trackDriver(String driverId, LatLng pickup) async* {
    Map<String, dynamic>? driver;
    try {
      driver = _drivers.firstWhere((d) => d['driverId'] == driverId);
    } catch (e) {
      return;
    }

    LatLng loc = driver['latLng'];
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final latDiff = pickup.latitude - loc.latitude;
      final lngDiff = pickup.longitude - loc.longitude;
      loc = LatLng(
        loc.latitude + latDiff * 0.02,
        loc.longitude + lngDiff * 0.02,
      );
      driver['latLng'] = loc;
      yield loc;
    }
  }

  // ----------------------
  // RIDE HISTORY
  // ----------------------
  final List<Map<String, dynamic>> _rideHistory = [
    {
      "pickup": "Main Square",
      "dropoff": "Airport",
      "fare": 120.0,
      "date": DateTime(2025, 8, 1, 10, 30),
      "status": "Completed",
    },
    {
      "pickup": "University",
      "dropoff": "Stadium",
      "fare": 80.0,
      "date": DateTime(2025, 8, 15, 14, 45),
      "status": "Cancelled",
    },
  ];

  Future<List<Map<String, dynamic>>> getRideHistory(String? phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_rideHistory);
  }

  Future<void> deleteRide(String rideId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _rideHistory.removeWhere((ride) => ride['rideId'] == rideId);
  }

  // ----------------------
  // NOTIFICATIONS
  // ----------------------
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'N001',
      'title': 'Ride Confirmed',
      'message': 'Your ride from Mekelle to Adigrat is booked.',
    },
    {
      'id': 'N002',
      'title': 'Driver Arriving',
      'message': 'Your driver will arrive in 5 minutes.',
    },
    {
      'id': 'N003',
      'title': 'Payment Successful',
      'message': 'You paid ETB 200 for your last trip.',
    },
  ];

  Future<List<Map<String, dynamic>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_notifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.removeWhere((n) => n['id'] == notificationId);
  }

  // ----------------------
  // DRIVER HELPERS
  // ----------------------
  Future<DriverModel?> fetchDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final driver = _drivers.firstWhere((d) => d['driverId'] == driverId);
      return DriverModel.fromMap(driver);
    } catch (e) {
      return null;
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../features/auth/domain/models/user.dart';
// import '../../features/driver/domain/models/driver.dart';

// class ApiService {
//   // ----------------------
//   // Singleton setup
//   // ----------------------
//   ApiService._privateConstructor();
//   static final ApiService _instance = ApiService._privateConstructor();
//   factory ApiService() => _instance;

//   // ----------------------
//   // Base URL of your backend
//   // ----------------------
//   final String baseUrl = "https://niyat-ride-1-q0om.onrender.com/api";

//   Future<String> sendOtp(String phone) async {
//     final url = Uri.parse("$baseUrl/customers/request-otp");

//     try {
//       // ✅ Print phone number before sending
//       print("Sending OTP to phone number: $phone");

//       final response = await http
//           .post(url, body: {'phoneNumber': phone})
//           .timeout(const Duration(seconds: 50));

//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");

//       if (response.statusCode == 200) {
//         return response.body.trim();
//       } else {
//         throw Exception("Failed to send OTP: ${response.body}");
//       }
//     } catch (e) {
//       print("Error sending OTP: $e");
//       rethrow;
//     }
//   }

//   // Verify OTP
//   Future<Map<String, dynamic>?> verifyOtp(
//     String phoneNumber,
//     String otp,
//   ) async {
//     final url = Uri.parse("$baseUrl/customers/verify-otp");

//     try {
//       final response = await http
//           .post(url, body: {'phoneNumber': phoneNumber, 'otp': otp})
//           .timeout(const Duration(seconds: 15));

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         return response.body.isNotEmpty
//             ? Map<String, dynamic>.from(
//               jsonDecode(response.body) as Map<String, dynamic>,
//             )
//             : null;
//       } else {
//         print("Failed to verify OTP: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Error verifying OTP: $e");
//       return null;
//     }
//   }

//   // 🔹 RESEND OTP
//   Future<String> resendOtp(String phoneNumber) async {
//     final url = Uri.parse("$baseUrl/resend-otp");
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"phone": phoneNumber}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["message"] ?? "OTP resent";
//     } else {
//       throw Exception("Failed to resend OTP: ${response.body}");
//     }
//   }

//   // // Update profile
//   // Future<UserModel?> updateProfile(
//   //   UserModel updatedUser,
//   //   int customerId,
//   // ) async {
//   //   final url = Uri.parse(
//   //     "https://niyat-ride-1-q0om.onrender.com/api/customers/updateCustomer/$customerId",
//   //   );

//   //   try {
//   //     final response = await http.patch(
//   //       url,
//   //       headers: {"Content-Type": "application/json"},
//   //       body: jsonEncode({
//   //         "firstName": updatedUser.firstName,
//   //         "lastName": updatedUser.lastName,
//   //         "email": updatedUser.email,
//   //       }),
//   //     );

//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       return UserModel.fromJson({
//   //         'id': data['id'],
//   //         'phone': data['phoneNumber'],
//   //         'firstName': data['firstName'],
//   //         'lastName': data['lastName'],
//   //         'email': data['email'],
//   //       });
//   //     } else {
//   //       print("Failed to update profile: ${response.body}");
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     print("Error updating profile: $e");
//   //     return null;
//   //   }
//   // }

//   Future<UserModel?> updateProfile(
//     UserModel updatedUser,
//     int customerId,
//   ) async {
//     final url = Uri.parse("$baseUrl/customers/updateCustomer/$customerId");

//     try {
//       final response = await http.patch(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(updatedUser.toJson()),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return UserModel.fromJson({
//           'id': data['id'],
//           'phoneNumber': data['phoneNumber'],
//           'firstName': data['firstName'],
//           'lastName': data['lastName'],
//           'email': data['email'],
//         });
//       } else {
//         print("Failed to update profile: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Error updating profile: $e");
//       return null;
//     }
//   }

//   // GET AVAILABLE CARS
//   Future<List<Map<String, dynamic>>> getAvailableCars() async {
//     final url = Uri.parse("$baseUrl/cars");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((car) => Map<String, dynamic>.from(car)).toList();
//     }
//     return [];
//   }

//   // ----------------------
//   // POST RIDE ORDER
//   // ----------------------
//   Future<Map<String, dynamic>> postRideOrder({
//     required LatLng pickup,
//     required LatLng dropoff,
//     required String carType,
//   }) async {
//     final url = Uri.parse("$baseUrl/rides");
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "pickup": {"lat": pickup.latitude, "lng": pickup.longitude},
//         "dropoff": {"lat": dropoff.latitude, "lng": dropoff.longitude},
//         "carType": carType,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Failed to book ride: ${response.body}");
//     }
//   }

//   // ----------------------
//   // DRIVER LOCATION
//   // ----------------------
//   Future<LatLng?> getDriverLocation(String driverId) async {
//     final url = Uri.parse("$baseUrl/drivers/$driverId/location");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return LatLng(data["lat"], data["lng"]);
//     }
//     return null;
//   }

//   // ----------------------
//   // RIDE HISTORY
//   // ----------------------
//   Future<List<Map<String, dynamic>>> getRideHistory(String phone) async {
//     final url = Uri.parse("$baseUrl/rides/history/$phone");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((ride) => Map<String, dynamic>.from(ride)).toList();
//     }
//     return [];
//   }

//   Future<void> deleteRide(String rideId) async {
//     final url = Uri.parse("$baseUrl/rides/$rideId");
//     final response = await http.delete(url);
//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete ride: ${response.body}");
//     }
//   }

//   // ----------------------
//   // NOTIFICATIONS
//   // ----------------------
//   Future<List<Map<String, dynamic>>> getNotifications() async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/notifications"),
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body);
//       return jsonData.map((n) => Map<String, dynamic>.from(n)).toList();
//     } else {
//       throw Exception("Failed to load notifications");
//     }
//   }

//   Future<void> deleteNotification(String notificationId) async {
//     final url = Uri.parse("$baseUrl/notifications/$notificationId");
//     final response = await http.delete(url);

//     if (response.statusCode != 200) {
//       throw Exception("Failed to delete notification: ${response.body}");
//     }
//   }

//   // ----------------------
//   // DRIVER HELPERS
//   // ----------------------
//   Future<DriverModel?> fetchDriver(String driverId) async {
//     final url = Uri.parse("$baseUrl/drivers/$driverId");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return DriverModel.fromMap(data);
//     }
//     return null;
//   }
// }
