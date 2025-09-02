// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/services/api_service.dart';
// import '../../../profile/presentation/screens/profile_add_screen.dart';
// import '../../../ride/presentation/screens/ride_booking_screen.dart';

// class OtpVerifyScreen extends StatefulWidget {
//   final String phone;
//   const OtpVerifyScreen({Key? key, required this.phone}) : super(key: key);

//   @override
//   State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
// }

// class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
//   String _otp = "";
//   bool _loading = false;
//   bool _showError = false;
//   int _resendCountdown = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }

//   void _startResendTimer() {
//     _resendCountdown = 30;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendCountdown == 0) {
//         timer.cancel();
//       } else {
//         setState(() => _resendCountdown--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   Future<void> _verifyOtp() async {
//     setState(() {
//       _loading = true;
//       _showError = false;
//     });

//     try {
//       final data = await ApiService().verifyOtp(widget.phone, _otp);

//       if (data != null && data['token'] != null) {
//         final token = data['token'];
//         final userExists = data['userExists'] as bool;

//         // Save token locally
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('jwt_token', token);

//         setState(() => _loading = false);

//         if (userExists) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const RideBookingScreen()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (_) => ProfileAddScreen(token: token, phone: widget.phone),
//             ),
//           );
//         }
//       } else {
//         setState(() {
//           _showError = true;
//           _loading = false;
//         });
//         HapticFeedback.vibrate();
//       }
//     } catch (e) {
//       setState(() {
//         _showError = true;
//         _loading = false;
//       });
//       HapticFeedback.vibrate();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Verification failed: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _resendOtp() async {
//     if (_resendCountdown == 0) {
//       try {
//         await ApiService().resendOtp(widget.phone);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("OTP resent"),
//             backgroundColor: Theme.of(context).primaryColor,
//           ),
//         );
//         _startResendTimer();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Failed to resend OTP: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         title: const Text("OTP Verification"),
//         backgroundColor: theme.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(Icons.lock_outline, size: 80, color: theme.primaryColor),
//               const SizedBox(height: 20),
//               Text(
//                 "Enter the 6-digit code sent to",
//                 style: theme.textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.phone,
//                 style: theme.textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: Colors.grey.shade400,
//                 focusedBorderColor: theme.primaryColor,
//                 showFieldAsBox: true,
//                 borderWidth: 2,
//                 fieldWidth:
//                     MediaQuery.of(context).size.width / 8, // responsive width
//                 borderRadius: BorderRadius.circular(12),
//                 keyboardType: TextInputType.number,
//                 textStyle: TextStyle(
//                   fontSize: 20, // smaller number size
//                   fontWeight: FontWeight.bold,
//                 ),
//                 onCodeChanged: (code) {
//                   setState(() {
//                     _otp = code;
//                     _showError = false;
//                   });
//                 },
//                 onSubmit: (code) {
//                   _otp = code;
//                   if (!_loading) _verifyOtp();
//                 },
//               ),

//               if (_showError)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: Text(
//                     "Invalid OTP, please try again.",
//                     style: TextStyle(color: theme.colorScheme.error),
//                   ),
//                 ),

//               const SizedBox(height: 30),

//               ElevatedButton(
//                 onPressed: _otp.length == 6 && !_loading ? _verifyOtp : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _otp.length == 6 && !_loading
//                           ? theme.primaryColor
//                           : Colors.grey.shade400,
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child:
//                     _loading
//                         ? const SizedBox(
//                           height: 24,
//                           width: 24,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         )
//                         : const Text(
//                           "Verify & Continue",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//               ),

//               const SizedBox(height: 30),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Didn't receive the code? ",
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                   TextButton(
//                     onPressed: _resendCountdown == 0 ? _resendOtp : null,
//                     child: Text(
//                       _resendCountdown == 0
//                           ? "Resend"
//                           : "Resend in $_resendCountdown s",
//                       style: TextStyle(
//                         color:
//                             _resendCountdown == 0
//                                 ? theme.primaryColor
//                                 : Colors.grey.shade500,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/services/api_service.dart';
// import '../../../ride/presentation/screens/ride_booking_screen.dart';

// class OtpVerifyScreen extends StatefulWidget {
//   final String phone;
//   const OtpVerifyScreen({Key? key, required this.phone}) : super(key: key);

//   @override
//   State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
// }

// class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
//   String _otp = "";
//   bool _loading = false;
//   bool _showError = false;
//   int _resendCountdown = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }

//   void _startResendTimer() {
//     _resendCountdown = 30;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendCountdown == 0) {
//         timer.cancel();
//       } else {
//         setState(() => _resendCountdown--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   Future<void> _verifyOtp() async {
//     setState(() {
//       _loading = true;
//       _showError = false;
//     });

//     try {
//       final data = await ApiService().verifyOtp(widget.phone, _otp);

//       if (data != null && data['token'] != null) {
//         final token = data['token'];

//         // Save token locally
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('jwt_token', token);

//         setState(() => _loading = false);

//         // Always navigate to RideBookingScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const RideBookingScreen()),
//         );
//       } else {
//         setState(() {
//           _showError = true;
//           _loading = false;
//         });
//         HapticFeedback.vibrate();
//       }
//     } catch (e) {
//       setState(() {
//         _showError = true;
//         _loading = false;
//       });
//       HapticFeedback.vibrate();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Verification failed: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _resendOtp() async {
//     if (_resendCountdown == 0) {
//       try {
//         await ApiService().resendOtp(widget.phone);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("OTP resent"),
//             backgroundColor: Theme.of(context).primaryColor,
//           ),
//         );
//         _startResendTimer();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Failed to resend OTP: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         title: const Text("OTP Verification"),
//         backgroundColor: theme.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(Icons.lock_outline, size: 80, color: theme.primaryColor),
//               const SizedBox(height: 20),
//               Text(
//                 "Enter the 6-digit code sent to",
//                 style: theme.textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.phone,
//                 style: theme.textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: Colors.grey.shade400,
//                 focusedBorderColor: theme.primaryColor,
//                 showFieldAsBox: true,
//                 borderWidth: 2,
//                 fieldWidth: MediaQuery.of(context).size.width / 8,
//                 borderRadius: BorderRadius.circular(12),
//                 keyboardType: TextInputType.number,
//                 textStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 onCodeChanged: (code) {
//                   setState(() {
//                     _otp = code;
//                     _showError = false;
//                   });
//                 },
//                 onSubmit: (code) {
//                   _otp = code;
//                   if (!_loading) _verifyOtp();
//                 },
//               ),
//               if (_showError)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: Text(
//                     "Invalid OTP, please try again.",
//                     style: TextStyle(color: theme.colorScheme.error),
//                   ),
//                 ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _otp.length == 6 && !_loading ? _verifyOtp : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _otp.length == 6 && !_loading
//                           ? theme.primaryColor
//                           : Colors.grey.shade400,
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child:
//                     _loading
//                         ? const SizedBox(
//                           height: 24,
//                           width: 24,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         )
//                         : const Text(
//                           "Verify & Continue",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Didn't receive the code? ",
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                   TextButton(
//                     onPressed: _resendCountdown == 0 ? _resendOtp : null,
//                     child: Text(
//                       _resendCountdown == 0
//                           ? "Resend"
//                           : "Resend in $_resendCountdown s",
//                       style: TextStyle(
//                         color:
//                             _resendCountdown == 0
//                                 ? theme.primaryColor
//                                 : Colors.grey.shade500,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/services/api_service.dart';
// import '../../../ride/presentation/screens/ride_booking_screen.dart';

// class OtpVerifyScreen extends StatefulWidget {
//   final String phone;
//   const OtpVerifyScreen({Key? key, required this.phone}) : super(key: key);

//   @override
//   State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
// }

// class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
//   String _otp = "";
//   bool _loading = false;
//   bool _showError = false;
//   int _resendCountdown = 30;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//   }

//   void _startResendTimer() {
//     _resendCountdown = 30;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendCountdown == 0) {
//         timer.cancel();
//       } else {
//         setState(() => _resendCountdown--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   Future<void> _verifyOtp() async {
//     setState(() {
//       _loading = true;
//       _showError = false;
//     });

//     try {
//       final data = await ApiService().verifyOtp(widget.phone, _otp);

//       if (data != null && data['token'] != null) {
//         final token = data['token'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('jwt_token', token);

//         setState(() => _loading = false);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const RideBookingScreen()),
//         );
//       } else {
//         setState(() {
//           _showError = true;
//           _loading = false;
//         });
//         HapticFeedback.vibrate();
//       }
//     } catch (e) {
//       setState(() {
//         _showError = true;
//         _loading = false;
//       });
//       HapticFeedback.vibrate();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Verification failed: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _resendOtp() async {
//     if (_resendCountdown == 0) {
//       try {
//         await ApiService().resendOtp(widget.phone);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("OTP resent"),
//             backgroundColor: Theme.of(context).primaryColor,
//           ),
//         );
//         _startResendTimer();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Failed to resend OTP: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         title: const Text("OTP Verification"),
//         backgroundColor: theme.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(Icons.lock_outline, size: 80, color: theme.primaryColor),
//               const SizedBox(height: 20),
//               Text(
//                 "Enter the 6-digit code sent to",
//                 style: theme.textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.phone,
//                 style: theme.textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               OtpTextField(
//                 numberOfFields: 6,
//                 borderColor: Colors.grey.shade400,
//                 focusedBorderColor: theme.primaryColor,
//                 showFieldAsBox: true,
//                 borderWidth: 2,
//                 fieldWidth: MediaQuery.of(context).size.width / 8,
//                 borderRadius: BorderRadius.circular(12),
//                 keyboardType: TextInputType.number,
//                 textStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 onCodeChanged: (code) {
//                   setState(() {
//                     _otp = code;
//                     _showError = false;
//                   });
//                 },
//                 onSubmit: (code) {
//                   _otp = code;
//                   if (!_loading) _verifyOtp();
//                 },
//               ),
//               if (_showError)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: Text(
//                     "Invalid OTP, please try again.",
//                     style: TextStyle(color: theme.colorScheme.error),
//                   ),
//                 ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _otp.length == 6 && !_loading ? _verifyOtp : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _otp.length == 6 && !_loading
//                           ? theme.primaryColor
//                           : Colors.grey.shade400,
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child:
//                     _loading
//                         ? const SizedBox(
//                           height: 24,
//                           width: 24,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         )
//                         : const Text(
//                           "Verify & Continue",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Didn't receive the code? ",
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                   TextButton(
//                     onPressed: _resendCountdown == 0 ? _resendOtp : null,
//                     child: Text(
//                       _resendCountdown == 0
//                           ? "Resend"
//                           : "Resend in $_resendCountdown s",
//                       style: TextStyle(
//                         color:
//                             _resendCountdown == 0
//                                 ? theme.primaryColor
//                                 : Colors.grey.shade500,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:nyat_ride_system/features/auth/domain/models/user.dart';
import 'package:nyat_ride_system/features/auth/presentation/controllers/user_controller.dart';
import '../../../../core/services/api_service.dart';
import '../../../ride/presentation/screens/ride_booking_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  const OtpVerifyScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String _otp = "";
  bool _loading = false;
  bool _showError = false;
  int _resendCountdown = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendCountdown = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Future<void> _verifyOtp() async {
  //   setState(() {
  //     _loading = true;
  //     _showError = false;
  //   });

  //   try {
  //     final data = await ApiService().verifyOtp(widget.phone, _otp);

  //     if (data != null) {
  //       setState(() => _loading = false);

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const RideBookingScreen()),
  //       );
  //     } else {
  //       setState(() {
  //         _showError = true;
  //         _loading = false;
  //       });
  //       HapticFeedback.vibrate();
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _showError = true;
  //       _loading = false;
  //     });
  //     HapticFeedback.vibrate();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Verification failed: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> _verifyOtp() async {
    setState(() {
      _loading = true;
      _showError = false;
    });

    try {
      final data = await ApiService().verifyOtp(widget.phone, _otp);

      if (data != null) {
        // ✅ Convert JSON to UserModel
        final user = UserModel.fromJson(data);

        // ✅ Store user in GetX controller
        final userController = Get.find<UserController>();
        userController.setUser(user);

        setState(() => _loading = false);

        // Navigate to next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RideBookingScreen()),
        );
      } else {
        setState(() {
          _showError = true;
          _loading = false;
        });
        HapticFeedback.vibrate();
      }
    } catch (e) {
      setState(() {
        _showError = true;
        _loading = false;
      });
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verification failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendOtp() async {
    if (_resendCountdown == 0) {
      try {
        await ApiService().resendOtp(widget.phone);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("OTP resent"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
        _startResendTimer();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to resend OTP: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: theme.primaryColor),
              const SizedBox(height: 20),
              Text(
                "Enter the 6-digit code sent to",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.phone,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.grey.shade400,
                focusedBorderColor: theme.primaryColor,
                showFieldAsBox: true,
                borderWidth: 2,
                fieldWidth: MediaQuery.of(context).size.width / 8,
                borderRadius: BorderRadius.circular(12),
                keyboardType: TextInputType.number,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onCodeChanged: (code) {
                  setState(() {
                    _otp = code;
                    _showError = false;
                  });
                },
                onSubmit: (code) {
                  _otp = code;
                  if (!_loading) _verifyOtp();
                },
              ),
              if (_showError)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "Invalid OTP, please try again.",
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _otp.length == 6 && !_loading ? _verifyOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _otp.length == 6 && !_loading
                          ? theme.primaryColor
                          : Colors.grey.shade400,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child:
                    _loading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                        : const Text(
                          "Verify & Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _resendCountdown == 0 ? _resendOtp : null,
                    child: Text(
                      _resendCountdown == 0
                          ? "Resend"
                          : "Resend in $_resendCountdown s",
                      style: TextStyle(
                        color:
                            _resendCountdown == 0
                                ? theme.primaryColor
                                : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
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
