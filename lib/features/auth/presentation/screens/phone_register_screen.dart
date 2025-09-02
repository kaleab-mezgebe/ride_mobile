// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/services/api_service.dart';
// import '../../../../core/utils/validators.dart';
// import '../../../../shared/widgets/terms_dialog.dart';
// import 'otp_verify_screen.dart';

// class PhoneRegisterScreen extends StatefulWidget {
//   const PhoneRegisterScreen({Key? key}) : super(key: key);

//   @override
//   State<PhoneRegisterScreen> createState() => _PhoneRegisterScreenState();
// }

// class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {
//   final _phoneCtrl = TextEditingController();
//   String _countryCode = "+251";
//   String _countryFlag = "🇪🇹"; // Default Ethiopia
//   bool _agree = false;
//   bool _loading = false;

//   void _pickCountry() {
//     final theme = Theme.of(context);
//     showCountryPicker(
//       context: context,
//       showPhoneCode: true,
//       countryListTheme: CountryListThemeData(
//         flagSize: 25,
//         backgroundColor: Colors.white,
//         textStyle: TextStyle(fontSize: 16, color: Colors.grey[800]),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(8.0),
//           topRight: Radius.circular(8.0),
//         ),
//         inputDecoration: InputDecoration(
//           labelText: 'Search',
//           hintText: 'Start typing to search',
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: theme.colorScheme.primary),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: theme.colorScheme.primary),
//           ),
//         ),
//       ),
//       onSelect: (country) {
//         setState(() {
//           _countryCode = "+${country.phoneCode}";
//           _countryFlag = country.flagEmoji;
//         });
//       },
//     );
//   }

//   bool get _isFormValid {
//     return Validators.isValidPhone(_phoneCtrl.text) && _agree;
//   }

//   Future<void> _sendOtp() async {
//     final phone = _phoneCtrl.text.trim(); // if you don’t want country code
//     print("Sending OTP to phone: $phone"); // <-- this will show in the terminal

//     setState(() => _loading = true);
//     try {
//       final message = await ApiService().sendOtp(phone);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.green),
//       );

//       if (!mounted) return;
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           transitionDuration: const Duration(milliseconds: 500),
//           pageBuilder: (_, __, ___) => OtpVerifyScreen(phone: phone),
//           transitionsBuilder:
//               (_, anim, __, child) =>
//                   ScaleTransition(scale: anim, child: child),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Failed to send OTP: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Login",
//           style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
//         ),
//         backgroundColor: theme.colorScheme.primary,
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Image.asset(
//                 'assets/images/welcome.png',
//                 width: 300,
//                 height: 300,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Enter your phone number",
//                     style: theme.textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "We will send you a verification code.",
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: Colors.grey[600],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             Row(
//               children: [
//                 InkWell(
//                   onTap: _pickCountry,
//                   borderRadius: BorderRadius.circular(8),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade400),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           _countryFlag,
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           _countryCode,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(width: 4),
//                         Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: _phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     onChanged: (_) => setState(() {}),
//                     decoration: InputDecoration(
//                       hintText: "912345678",
//                       hintStyle: TextStyle(color: Colors.grey[500]),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade400),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(
//                           color: theme.colorScheme.primary,
//                           width: 1.5,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Checkbox(
//                   value: _agree,
//                   onChanged: (v) => setState(() => _agree = v!),
//                   activeColor: theme.colorScheme.primary,
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap:
//                         () => showDialog(
//                           context: context,
//                           builder: (_) => const TermsDialog(),
//                         ),
//                     child: RichText(
//                       text: TextSpan(
//                         text: "I agree to the ",
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey[800],
//                         ),
//                         children: [
//                           TextSpan(
//                             text: "Terms & Conditions",
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: theme.colorScheme.primary,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: _isFormValid && !_loading ? _sendOtp : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       _isFormValid
//                           ? theme.colorScheme.primary
//                           : Colors.grey[400],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   shadowColor:
//                       _isFormValid
//                           ? theme.colorScheme.primary.withOpacity(0.3)
//                           : Colors.transparent,
//                 ),
//                 child:
//                     _loading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                           "Get Code",
//                           style: theme.textTheme.labelLarge?.copyWith(
//                             color: Colors.white,
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/terms_dialog.dart';
import 'otp_verify_screen.dart';

class PhoneRegisterScreen extends StatefulWidget {
  const PhoneRegisterScreen({Key? key}) : super(key: key);

  @override
  State<PhoneRegisterScreen> createState() => _PhoneRegisterScreenState();
}

class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {
  final _phoneCtrl = TextEditingController();
  String _countryCode = "+251";
  String _countryFlag = "🇪🇹"; // Default Ethiopia
  bool _agree = false;
  bool _loading = false;

  void _pickCountry() {
    final theme = Theme.of(context);
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.grey[800]),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
        ),
      ),
      onSelect: (country) {
        setState(() {
          _countryCode = "+${country.phoneCode}";
          _countryFlag = country.flagEmoji;
        });
      },
    );
  }

  bool get _isFormValid {
    return Validators.isValidPhone(_phoneCtrl.text) && _agree;
  }

  Future<void> _sendOtp() async {
    final phone = _phoneCtrl.text.trim(); // no country code added
    setState(() => _loading = true);

    try {
      // Send OTP via ApiService
      final message = await ApiService().sendOtp(phone);
      print("OTP request sent to: $phone");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );

      // Navigate to OTP verification screen
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => OtpVerifyScreen(phone: phone),
          transitionsBuilder:
              (_, anim, __, child) =>
                  ScaleTransition(scale: anim, child: child),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send OTP: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/welcome.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter your phone number",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We will send you a verification code.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                InkWell(
                  onTap: _pickCountry,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _countryFlag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _countryCode,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "912345678",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v!),
                  activeColor: theme.colorScheme.primary,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => showDialog(
                          context: context,
                          builder: (_) => const TermsDialog(),
                        ),
                    child: RichText(
                      text: TextSpan(
                        text: "I agree to the ",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[800],
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isFormValid && !_loading ? _sendOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFormValid
                          ? theme.colorScheme.primary
                          : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Get Code",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
