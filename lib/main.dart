import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'shared/theme/app_theme.dart';
import '../features/auth/presentation/controllers/user_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.configureSystemUI(isDark: false); // initial light mode
  Get.put(UserController()); // Singleton instance
  runApp(const NyatApp());
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Google Map Test',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MapTestScreen(),
//     );
//   }
// }

// class MapTestScreen extends StatefulWidget {
//   const MapTestScreen({super.key});

//   @override
//   State<MapTestScreen> createState() => _MapTestScreenState();
// }

// class _MapTestScreenState extends State<MapTestScreen> {
//   GoogleMapController? _controller;
//   final LatLng _testLocation = const LatLng(13.4967, 39.4750);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Google Map Test')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(target: _testLocation, zoom: 14),
//         markers: {
//           Marker(
//             markerId: const MarkerId('test_marker'),
//             position: _testLocation,
//             infoWindow: const InfoWindow(title: "Test Marker"),
//           ),
//         },
//         onMapCreated: (controller) {
//           _controller = controller;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Map loaded successfully!')),
//           );
//         },
//         myLocationButtonEnabled: false,
//         compassEnabled: true,
//       ),
//     );
//   }
// }
