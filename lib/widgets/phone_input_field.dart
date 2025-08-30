// import 'package:flutter/material.dart';

// class PhoneInputField extends StatelessWidget {
//   final TextEditingController phoneCtrl;
//   final String countryCode;
//   final String countryFlag;
//   final VoidCallback onTap;
//   final ValueChanged<String> onChanged;

//   const PhoneInputField({
//     Key? key,
//     required this.phoneCtrl,
//     required this.countryCode,
//     required this.countryFlag,
//     required this.onTap,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Row(
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade400),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Text(countryFlag, style: const TextStyle(fontSize: 20)),
//                 const SizedBox(width: 8),
//                 Text(countryCode, style: const TextStyle(fontSize: 16)),
//                 const SizedBox(width: 4),
//                 Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: TextField(
//             controller: phoneCtrl,
//             keyboardType: TextInputType.phone,
//             onChanged: onChanged,
//             decoration: InputDecoration(
//               hintText: "912345678",
//               hintStyle: TextStyle(color: Colors.grey[500]),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade400),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(
//                   color: theme.colorScheme.primary,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
// }
