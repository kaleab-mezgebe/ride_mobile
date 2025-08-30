import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/user.dart';

/// Mock API service to simulate backend endpoints.
/// This allows UI development/testing without integrating the real backend.
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
  String? _token; // mock auth token
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
  // 🔹 OTP REQUEST
  // ----------------------
  Future<String> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    final otp = "123456"; // fixed OTP for demo
    _otpStorage[phoneNumber] = otp;
    return "OTP sent to $phoneNumber";
  }

  // ----------------------
  // 🔹 OTP VERIFICATION
  Future<Map<String, dynamic>?> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_otpStorage[phoneNumber] == otp) {
      _otpStorage.remove(phoneNumber);

      // Assign a mock token after OTP verification
      _token = "mock_jwt_token_for_$phoneNumber";

      // Check if user exists in _users map
      bool userExists = _users.containsKey(phoneNumber);

      return {
        "token": _token,
        "userExists": userExists,
        "user":
            userExists
                ? _users[phoneNumber]!
                    .toJson() // return stored user data
                : {
                  "phone": phoneNumber,
                  "firstName": "", // empty for new user
                  "lastName": "",
                  "email": "",
                },
      };
    } else {
      return null; // invalid OTP
    }
  }

  // ----------------------
  // GET USER PROFILE
  Future<UserModel?> getUserProfile(String token) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_token == token) {
      // find the user for this token
      final phone = token.replaceFirst("mock_jwt_token_for_", "");
      return _users[phone] ??
          UserModel(phone: phone, firstName: "", lastName: "", email: "");
    } else {
      return null; // token invalid → treat as new user
    }
  }

  // ----------------------
  // 🔹 RESEND OTP
  Future<String> resendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    if (phoneNumber.isEmpty)
      throw Exception("Cannot resend OTP: invalid phone");

    // Generate a new OTP (for mock, still fixed)
    final otp = "123456";
    _otpStorage[phoneNumber] = otp;

    return "OTP resent to $phoneNumber";
  }

  // ----------------------
  // UPDATE PROFILE
  Future<bool> updateProfile(String token, UserModel updatedUser) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_token == token) {
      _users[updatedUser.phone] = updatedUser; // store/update user
      return true;
    }
    return false;
  }

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
    required String token,
    required LatLng pickup,
    required LatLng dropoff,
    required String carType,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (token.isEmpty) throw Exception("Invalid token");

    final car = _cars.firstWhere((c) => c["type"] == carType);
    final distance = _calculateDistanceKm(pickup, dropoff);
    final price = car["basePrice"] + (car["perKmPrice"] * distance);

    return {
      "rideId": DateTime.now().millisecondsSinceEpoch.toString(),
      "carType": carType,
      "pickup": pickup,
      "dropoff": dropoff,
      "distanceKm": distance,
      "price": price,
      "status": "pending",
    };
  }

  // ----------------------
  // Ride history
  // ----------------------
  static final List<Map<String, dynamic>> _rideHistory = [
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

  Future<List<Map<String, dynamic>>> getRideHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_rideHistory);
  }

  Future<void> deleteRide(int index) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (index >= 0 && index < _rideHistory.length) _rideHistory.removeAt(index);
  }

  // ----------------------
  // Notifications
  // ----------------------
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Ride Confirmed',
      'message': 'Your ride from Mekelle to Adigrat is booked.',
    },
    {
      'title': 'Driver Arriving',
      'message': 'Your driver will arrive in 5 minutes.',
    },
    {
      'title': 'Payment Successful',
      'message': 'You paid ETB 200 for your last trip.',
    },
  ];

  Future<List<Map<String, String>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Map<String, String>>.from(_notifications);
  }

  Future<void> deleteNotification(int index) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (index >= 0 && index < _notifications.length)
      _notifications.removeAt(index);
  }

  // ----------------------
  // Logout
  // ----------------------
  void logout() {
    _token = null;
  }
}
