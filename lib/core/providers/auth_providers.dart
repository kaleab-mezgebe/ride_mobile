import 'package:flutter/material.dart';
import '../../features/auth/domain/models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserModel? _user;
  String? _token;
  bool _loading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get loading => _loading;
  bool get isAuthenticated => _token != null;

  // ----------------------
  // SEND OTP
  // ----------------------
  Future<bool> sendOtp(String phone) async {
    _loading = true;
    notifyListeners();
    try {
      await _apiService.sendOtp(phone);
      return true;
    } catch (_) {
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ----------------------
  // VERIFY OTP
  // ----------------------
  Future<bool> verifyOtp(String phone, String otp) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await _apiService.verifyOtp(phone, otp);
      if (data != null && data['token'] != null) {
        _token = data['token'];

        // If user exists, populate _user
        if (data['userExists'] == true && data['user'] != null) {
          _user = UserModel.fromJson(data['user']);
        } else {
          _user = null;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ----------------------
  // UPDATE PROFILE
  // ----------------------
  // Future<bool> updateProfile(UserModel updatedUser) async {
  //   if (_token == null) return false;
  //   _loading = true;
  //   notifyListeners();
  //   try {
  //     final ok = await _apiService.updateProfile(updatedUser);
  //     if (ok) {
  //       _user = updatedUser;
  //     }
  //     return ok;
  //   } catch (_) {
  //     return false;
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  // ----------------------
  // GET USER PROFILE
  // ----------------------
  // Future<UserModel?> fetchUserProfile() async {
  //   if (_token == null) return null;
  //   try {
  //     final profile = await _apiService.getUserProfile(_token!);
  //     _user = profile;
  //     notifyListeners();
  //     return profile;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // ----------------------
  // LOGOUT
  // ----------------------
  void logout() {
    _user = null; // clear the current user
    notifyListeners(); // notify UI of changes
  }
}
