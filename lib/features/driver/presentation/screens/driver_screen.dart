// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// import '../../../../shared/widgets/map_widget.dart';
// import '../../../../core/constants/flutter_maps/secrets.dart';
// import '../../../../shared/theme/app_theme.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DriverScreen extends StatefulWidget {
//   final LatLng pickupLocation;
//   final LatLng dropoffLocation;
//   final String rideType;

//   const DriverScreen({
//     Key? key,
//     required this.pickupLocation,
//     required this.dropoffLocation,
//     required this.rideType,
//   }) : super(key: key);

//   @override
//   State<DriverScreen> createState() => _DriverScreenState();
// }

// class _DriverScreenState extends State<DriverScreen> {
//   GoogleMapController? _mapController;

//   // Driver & routing
//   LatLng? _driverLocation;
//   List<LatLng> _routePolyline = [];
//   double? _distanceKm;
//   double? _durationMin;
//   int _currentPolylineIndex = 0;
//   bool _headingToPickup = true;
//   Timer? _timer;

//   // UI state
//   bool _rideConfirmed = false; // after user taps Confirm Ride
//   bool _showDriverBubble = false; // show small circle bubble during trip
//   bool _busyRouting = false;

//   final PolylinePoints _polylinePoints = PolylinePoints();

//   final Map<String, String> _driverInfo = {
//     "firstName": "Abebe",
//     "lastName": "Tesfaye",
//     "gender": "Male",
//     "phone": "+251912345678",
//     "picture": "https://i.pravatar.cc/150?img=12",
//     "carPicture": "https://i.pravatar.cc/150?img=14",
//     "plateNumber": "ETH-1234",
//   };

//   @override
//   void initState() {
//     super.initState();
//     // Show the confirmation modal after first frame to avoid localization crash
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _showDriverConfirmationModal();
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   // -------------------- SIMULATION / ROUTING --------------------

//   void _startTrip() {
//     // Position driver a bit away from pickup to start the approach
//     final LatLng initial = LatLng(
//       widget.pickupLocation.latitude + 0.02,
//       widget.pickupLocation.longitude + 0.02,
//     );

//     setState(() {
//       _driverLocation = initial;
//       _rideConfirmed = true;
//       _headingToPickup = true;
//       _showDriverBubble = true; // keep bubble visible during the whole trip
//     });

//     // Draw route to pickup and start moving
//     _drawRoute(destination: widget.pickupLocation).then((_) {
//       _startMoving();
//     });
//   }

//   void _startMoving() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
//       _tickMove();
//     });
//   }

//   void _tickMove() {
//     if (_routePolyline.isEmpty) return;

//     // Move faster by jumping several points each tick
//     const step = 5;
//     _currentPolylineIndex = (_currentPolylineIndex + step).clamp(
//       0,
//       _routePolyline.length - 1,
//     );

//     setState(() {
//       _driverLocation = _routePolyline[_currentPolylineIndex];
//     });

//     // Keep the camera following
//     if (_driverLocation != null) {
//       _mapController?.animateCamera(CameraUpdate.newLatLng(_driverLocation!));
//     }

//     // Check arrival
//     final LatLng target =
//         _headingToPickup ? widget.pickupLocation : widget.dropoffLocation;
//     final d = _distanceInKm(
//       _driverLocation!.latitude,
//       _driverLocation!.longitude,
//       target.latitude,
//       target.longitude,
//     );

//     if (d < 0.03) {
//       // reached
//       _timer?.cancel();
//       if (_headingToPickup) {
//         _onReachedPickup();
//       } else {
//         _onReachedDropoff();
//       }
//     }
//   }

//   Future<void> _drawRoute({
//     required LatLng destination,
//     bool resetIndex = true,
//   }) async {
//     if (_driverLocation == null || _busyRouting) return;

//     setState(() => _busyRouting = true);
//     try {
//       final String apiKey = Secrets.API_KEY;
//       final url =
//           "https://maps.googleapis.com/maps/api/directions/json?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['routes'] == null || data['routes'].isEmpty) {
//           return;
//         }

//         final points = data['routes'][0]['overview_polyline']['points'];
//         final decoded = _polylinePoints.decodePolyline(points);

//         setState(() {
//           _routePolyline =
//               decoded.map((e) => LatLng(e.latitude, e.longitude)).toList();
//           if (resetIndex) _currentPolylineIndex = 0;

//           _distanceKm =
//               (data['routes'][0]['legs'][0]['distance']['value'] as num) / 1000;
//           _durationMin =
//               (data['routes'][0]['legs'][0]['duration']['value'] as num) / 60;
//         });

//         // Fit the entire route in view on first draw
//         if (_mapController != null && _routePolyline.isNotEmpty) {
//           final bounds = _getBounds(_routePolyline);
//           await _mapController!.animateCamera(
//             CameraUpdate.newLatLngBounds(bounds, 60),
//           );
//         }
//       }
//     } finally {
//       if (mounted) setState(() => _busyRouting = false);
//     }
//   }

//   // When the driver reaches pickup
//   void _onReachedPickup() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Text("Driver Arrived"),
//             content: const Text("The driver has reached your pickup location."),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context); // close dialog
//                   setState(() => _headingToPickup = false);
//                   // Redraw route to dropoff and continue moving
//                   await _drawRoute(destination: widget.dropoffLocation);
//                   _startMoving();
//                 },
//                 child: Text(
//                   "Start Trip",
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   // When the driver reaches dropoff
//   void _onReachedDropoff() {
//     _showRatingDialog();
//   }

//   // -------------------- UI HELPERS --------------------

//   LatLngBounds _getBounds(List<LatLng> pts) {
//     double south = pts.first.latitude, north = pts.first.latitude;
//     double west = pts.first.longitude, east = pts.first.longitude;
//     for (final p in pts) {
//       if (p.latitude < south) south = p.latitude;
//       if (p.latitude > north) north = p.latitude;
//       if (p.longitude < west) west = p.longitude;
//       if (p.longitude > east) east = p.longitude;
//     }
//     return LatLngBounds(
//       southwest: LatLng(south, west),
//       northeast: LatLng(north, east),
//     );
//   }

//   double _distanceInKm(double lat1, double lng1, double lat2, double lng2) {
//     const R = 6371.0;
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLng = _deg2rad(lng2 - lng1);
//     final a =
//         sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLng / 2) *
//             sin(dLng / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _deg2rad(double d) => d * (pi / 180);

//   // -------------------- ACTIONS --------------------
//   Future<void> _callDriver() async {
//     final number = _driverInfo["phone"] ?? "";
//     if (number.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Driver phone number not available")),
//       );
//       return;
//     }

//     // Check call permission
//     var status = await Permission.phone.status;
//     if (!status.isGranted) {
//       status = await Permission.phone.request();
//     }

//     if (status.isGranted) {
//       await FlutterPhoneDirectCaller.callNumber(number);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Phone call permission denied")),
//       );
//     }
//   }

//   void _cancelRideInternal() {
//     _timer?.cancel();
//     Navigator.of(context).pop(); // back to previous screen
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Ride canceled")));
//   }

//   // -------------------- MODALS / SHEETS --------------------
//   // First screen: confirm/cancel (Uber-like)
//   void _showDriverConfirmationModal() {
//     String selectedPayment = "Cash"; // default payment

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => StatefulBuilder(
//             builder:
//                 (context, setS) => DraggableScrollableSheet(
//                   initialChildSize: 0.45,
//                   minChildSize: 0.35,
//                   maxChildSize: 0.88,
//                   expand: false,
//                   builder:
//                       (context, scrollController) => Container(
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColorLight,
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(22),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               blurRadius: 14,
//                               spreadRadius: 2,
//                               offset: const Offset(0, -2),
//                             ),
//                           ],
//                         ),
//                         child: SingleChildScrollView(
//                           controller: scrollController,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 18,
//                             vertical: 18,
//                           ),
//                           child: Column(
//                             children: [
//                               // Grab handle
//                               Container(
//                                 width: 46,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black12,
//                                   borderRadius: BorderRadius.circular(3),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Driver card
//                               Container(
//                                 padding: const EdgeInsets.all(14),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.12),
//                                       blurRadius: 14,
//                                       spreadRadius: 1,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: _showFullDriverInfoModal,
//                                       child: CircleAvatar(
//                                         radius: 34,
//                                         backgroundImage: NetworkImage(
//                                           _driverInfo['picture']!,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "${_driverInfo['firstName']} ${_driverInfo['lastName']}",
//                                             style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 2),
//                                           Text(
//                                             "Car: ${widget.rideType}  •  Plate: ${_driverInfo['plateNumber']}",
//                                             style: const TextStyle(
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 6),
//                                           GestureDetector(
//                                             onTap: _callDriver,
//                                             child: Text(
//                                               _driverInfo['phone']!,
//                                               style: TextStyle(
//                                                 color:
//                                                     Theme.of(
//                                                       context,
//                                                     ).primaryColor,
//                                                 fontWeight: FontWeight.w600,
//                                                 decoration:
//                                                     TextDecoration.underline,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: _callDriver,
//                                       icon: const Icon(Icons.call),
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               const SizedBox(height: 16),
//                               Text(
//                                 "Driver is ready to pick you",
//                                 style: TextStyle(color: Colors.grey[700]),
//                               ),
//                               const SizedBox(height: 16),

//                               // Payment mode dropdown
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   "Payment Method",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.black12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.08),
//                                       blurRadius: 6,
//                                       spreadRadius: 1,
//                                     ),
//                                   ],
//                                 ),
//                                 child: DropdownButton<String>(
//                                   value: selectedPayment,
//                                   isExpanded: true,
//                                   underline: const SizedBox(),
//                                   items:
//                                       ["Cash"].map((e) {
//                                         return DropdownMenuItem(
//                                           value: e,
//                                           child: Text(e),
//                                         );
//                                       }).toList(),
//                                   onChanged: (v) {
//                                     if (v != null)
//                                       setS(() => selectedPayment = v);
//                                   },
//                                 ),
//                               ),

//                               const SizedBox(height: 18),

//                               // Confirm + Cancel
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                         _startTrip();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             Theme.of(context).primaryColor,
//                                         foregroundColor: Colors.white,
//                                         elevation: 6,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 14,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Confirm Ride",
//                                         style: TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: _showCancelRideConfirmation,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.redAccent,
//                                         foregroundColor: Colors.white,
//                                         elevation: 6,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 14,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Cancel Ride",
//                                         style: TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                 ),
//           ),
//     );
//   }

//   // Full driver details (tap avatar/bubble)
//   void _showFullDriverInfoModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => DraggableScrollableSheet(
//             initialChildSize: 0.88,
//             minChildSize: 0.6,
//             maxChildSize: 0.95,
//             expand: false,
//             builder:
//                 (context, scrollController) => Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColorLight,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(22),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.25),
//                         blurRadius: 14,
//                         spreadRadius: 2,
//                         offset: const Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     padding: const EdgeInsets.all(18),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 46,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         CircleAvatar(
//                           radius: 48,
//                           backgroundImage: NetworkImage(
//                             _driverInfo['picture']!,
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         GestureDetector(
//                           onTap: _callDriver,
//                           child: Text(
//                             _driverInfo['phone']!,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Theme.of(context).primaryColor,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         Text(
//                           "${_driverInfo['firstName']} ${_driverInfo['lastName']}",
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Car: ${widget.rideType}  •  Plate: ${_driverInfo['plateNumber']}",
//                           style: const TextStyle(color: Colors.black54),
//                         ),
//                         const SizedBox(height: 14),

//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.network(
//                             _driverInfo['carPicture']!,
//                             height: 190,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(height: 14),

//                         // Rating row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(5, (i) {
//                             return Icon(
//                               i < 4 ? Icons.star : Icons.star_border,
//                               color: Colors.amber,
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 6),
//                         const Text(
//                           "Rated 4.0 by 120 riders",
//                           style: TextStyle(color: Colors.black54),
//                         ),

//                         const SizedBox(height: 18),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton.icon(
//                                 onPressed: _callDriver,
//                                 icon: const Icon(Icons.call),
//                                 label: const Text("Call"),
//                                 style: OutlinedButton.styleFrom(
//                                   side: BorderSide(
//                                     color: Theme.of(context).primaryColor,
//                                     width: 1.2,
//                                   ),
//                                   foregroundColor:
//                                       Theme.of(context).primaryColor,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                 onPressed: _showCancelRideConfirmation,
//                                 icon: const Icon(Icons.close),
//                                 label: const Text("Cancel Ride"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.redAccent,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                   ),
//                                   elevation: 6,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//           ),
//     );
//   }

//   void _showCancelRideConfirmation() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Text("Cancel Ride"),
//             content: const Text("Are you sure you want to cancel this ride?"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("No"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // closes the bottom sheet
//                   Navigator.of(
//                     context,
//                   ).pop(); // navigates back to previous screen
//                   _cancelRideInternal();
//                 },
//                 child: const Text("Yes", style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showRatingDialog() {
//     int selected = 0;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) => StatefulBuilder(
//             builder:
//                 (context, setS) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   title: const Text("Rate Your Trip"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(5, (i) {
//                           return IconButton(
//                             onPressed: () => setS(() => selected = i + 1),
//                             icon: Icon(
//                               i < selected ? Icons.star : Icons.star_border,
//                               color: Colors.amber,
//                               size: 28,
//                             ),
//                           );
//                         }),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text("Thanks for riding with us!"),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context); // close rating
//                         Navigator.pop(context); // go back
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Thanks for your feedback!"),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "Submit",
//                         style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//           ),
//     );
//   }

//   // -------------------- BUILD --------------------

//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.light();
//     final primary = theme.colorScheme.primary;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver on the way"),
//         backgroundColor: primary,
//         actions: [
//           if (_rideConfirmed)
//             IconButton(
//               tooltip: "Driver details",
//               onPressed: _showFullDriverInfoModal,
//               icon: const Icon(Icons.info_outline),
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Map
//           Positioned.fill(
//             child:
//                 _driverLocation == null
//                     ? const Center(child: CircularProgressIndicator())
//                     : MapWidget(
//                       mapController: _mapController,
//                       currentLocation: _driverLocation,
//                       driverLocation: _driverLocation,
//                       pickupPoint: widget.pickupLocation,
//                       dropoffPoint: widget.dropoffLocation,
//                       routePolyline: _routePolyline,
//                       primaryColor: primary,
//                       routeDistanceKm: _distanceKm,
//                       routeDurationMin: _durationMin,
//                       onMapCreated: (c) => _mapController = c,
//                     ),
//           ),

//           // Floating driver bubble (Messenger-like)
//           if (_showDriverBubble)
//             Positioned(
//               bottom: 120,
//               left: 16,
//               child: GestureDetector(
//                 onTap: _showFullDriverInfoModal,
//                 child: Container(
//                   padding: const EdgeInsets.all(3),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.18),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     radius: 28,
//                     backgroundImage: NetworkImage(_driverInfo['picture']!),
//                   ),
//                 ),
//               ),
//             ),

//           // Show the initial confirmation modal automatically only once from initState
//         ],
//       ),
//       floatingActionButton:
//           (!_rideConfirmed)
//               ? FloatingActionButton.extended(
//                 onPressed: _showDriverConfirmationModal,
//                 backgroundColor: primary,
//                 icon: const Icon(Icons.local_taxi),
//                 label: const Text("Driver details"),
//               )
//               : null,
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/flutter_maps/secrets.dart';
import '../../../../shared/theme/app_theme.dart';
import '../widgets/driver_map.dart';
import '../widgets/driver_bubble.dart';
import '../widgets/driver_confirmation_modal.dart';
import '../widgets/full_driver_info_modal.dart';

class DriverScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String rideType;

  const DriverScreen({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.rideType,
    required String driverId,
  }) : super(key: key);

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  GoogleMapController? _mapController;

  // Driver & routing
  LatLng? _driverLocation;
  List<LatLng> _routePolyline = [];
  double? _distanceKm;
  double? _durationMin;
  int _currentPolylineIndex = 0;
  bool _headingToPickup = true;
  Timer? _timer;
  bool _rideConfirmed = false;
  bool _showDriverBubble = false;
  bool _busyRouting = false;

  final PolylinePoints _polylinePoints = PolylinePoints();

  final Map<String, String> _driverInfo = {
    "firstName": "Abebe",
    "lastName": "Tesfaye",
    "gender": "Male",
    "phone": "+251912345678",
    "picture": "https://i.pravatar.cc/150?img=12",
    "carPicture": "https://i.pravatar.cc/150?img=14",
    "plateNumber": "ETH-1234",
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDriverConfirmationModal();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -------------------- SIMULATION / ROUTING --------------------

  void _startTrip() {
    final LatLng initial = LatLng(
      widget.pickupLocation.latitude + 0.02,
      widget.pickupLocation.longitude + 0.02,
    );

    setState(() {
      _driverLocation = initial;
      _rideConfirmed = true;
      _headingToPickup = true;
      _showDriverBubble = true;
    });

    _drawRoute(destination: widget.pickupLocation).then((_) => _startMoving());
  }

  void _startMoving() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _tickMove();
    });
  }

  void _tickMove() {
    if (_routePolyline.isEmpty) return;

    const step = 5;
    _currentPolylineIndex = (_currentPolylineIndex + step).clamp(
      0,
      _routePolyline.length - 1,
    );

    setState(() {
      _driverLocation = _routePolyline[_currentPolylineIndex];
    });

    if (_driverLocation != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(_driverLocation!));
    }

    final LatLng target =
        _headingToPickup ? widget.pickupLocation : widget.dropoffLocation;
    final d = _distanceInKm(
      _driverLocation!.latitude,
      _driverLocation!.longitude,
      target.latitude,
      target.longitude,
    );

    if (d < 0.03) {
      _timer?.cancel();
      if (_headingToPickup) {
        _onReachedPickup();
      } else {
        _onReachedDropoff();
      }
    }
  }

  Future<void> _drawRoute({
    required LatLng destination,
    bool resetIndex = true,
  }) async {
    if (_driverLocation == null || _busyRouting) return;

    setState(() => _busyRouting = true);
    try {
      final String apiKey = Secrets.API_KEY;
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] == null || data['routes'].isEmpty) return;

        final points = data['routes'][0]['overview_polyline']['points'];
        final decoded = _polylinePoints.decodePolyline(points);

        setState(() {
          _routePolyline =
              decoded.map((e) => LatLng(e.latitude, e.longitude)).toList();
          if (resetIndex) _currentPolylineIndex = 0;
          _distanceKm =
              (data['routes'][0]['legs'][0]['distance']['value'] as num) / 1000;
          _durationMin =
              (data['routes'][0]['legs'][0]['duration']['value'] as num) / 60;
        });

        if (_mapController != null && _routePolyline.isNotEmpty) {
          final bounds = _getBounds(_routePolyline);
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 60),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _busyRouting = false);
    }
  }

  void _onReachedPickup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Driver Arrived"),
            content: const Text("The driver has reached your pickup location."),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _headingToPickup = false);
                  await _drawRoute(destination: widget.dropoffLocation);
                  _startMoving();
                },
                child: Text(
                  "Start Trip",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _onReachedDropoff() {
    _showRatingDialog();
  }

  LatLngBounds _getBounds(List<LatLng> pts) {
    double south = pts.first.latitude, north = pts.first.latitude;
    double west = pts.first.longitude, east = pts.first.longitude;
    for (final p in pts) {
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

  double _distanceInKm(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLng = _deg2rad(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double d) => d * (pi / 180);

  // -------------------- ACTIONS --------------------

  Future<void> _callDriver() async {
    final number = _driverInfo["phone"] ?? "";
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Driver phone number not available")),
      );
      return;
    }

    var status = await Permission.phone.status;
    if (!status.isGranted) status = await Permission.phone.request();
    if (status.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(number);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone call permission denied")),
      );
    }
  }

  void _cancelRideInternal() {
    _timer?.cancel();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Ride canceled")));
  }

  void _showDriverConfirmationModal() {
    showDriverConfirmationModal(
      context: context,
      rideType: widget.rideType,
      driverInfo: _driverInfo,
      onConfirm: _startTrip,
      onCancel: _showCancelRideConfirmation,
      onCall: _callDriver,
    );
  }

  void _showCancelRideConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Cancel Ride"),
            content: const Text("Are you sure you want to cancel this ride?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _cancelRideInternal();
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showRatingDialog() {
    int selected = 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setS) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text("Rate Your Trip"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return IconButton(
                            onPressed: () => setS(() => selected = i + 1),
                            icon: Icon(
                              i < selected ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 28,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      const Text("Thanks for riding with us!"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thanks for your feedback!"),
                          ),
                        );
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light();
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver on the way"),
        backgroundColor: primary,
        actions: [
          if (_rideConfirmed)
            IconButton(
              tooltip: "Driver details",
              onPressed:
                  () => showFullDriverInfoModal(
                    context: context,
                    rideType: widget.rideType,
                    driverInfo: _driverInfo,
                    onCall: _callDriver,
                    onCancel: _showCancelRideConfirmation,
                  ),
              icon: const Icon(Icons.info_outline),
            ),
        ],
      ),
      body: Stack(
        children: [
          DriverMap(
            mapController: _mapController,
            driverLocation: _driverLocation,
            pickupLocation: widget.pickupLocation,
            dropoffLocation: widget.dropoffLocation,
            routePolyline: _routePolyline,
            distanceKm: _distanceKm,
            durationMin: _durationMin,
            primaryColor: primary,
            onMapCreated: (c) => _mapController = c,
          ),
          if (_showDriverBubble)
            DriverBubble(
              driverPicture: _driverInfo['picture']!,
              onTap: () {
                showFullDriverInfoModal(
                  context: context,
                  rideType: widget.rideType,
                  driverInfo: _driverInfo,
                  onCall: _callDriver,
                  onCancel: _showCancelRideConfirmation,
                );
              },
            ),
        ],
      ),
      floatingActionButton:
          (!_rideConfirmed)
              ? FloatingActionButton.extended(
                onPressed: _showDriverConfirmationModal,
                backgroundColor: primary,
                icon: const Icon(Icons.local_taxi),
                label: const Text("Driver details"),
              )
              : null,
    );
  }
}
