// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapWidget extends StatelessWidget {
//   final GoogleMapController? mapController;
//   final LatLng? currentLocation;
//   final LatLng? pickupPoint;
//   final LatLng? dropoffPoint;
//   final List<LatLng> routePolyline;
//   final Color primaryColor;
//   final double? routeDistanceKm;
//   final double? routeDurationMin;
//   final Function(GoogleMapController controller)? onMapCreated;

//   const MapWidget({
//     Key? key,
//     this.mapController,
//     required this.currentLocation,
//     required this.pickupPoint,
//     required this.dropoffPoint,
//     required this.routePolyline,
//     required this.primaryColor,
//     this.routeDistanceKm,
//     this.routeDurationMin,
//     this.onMapCreated,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Set<Marker> markers = {};
//     if (currentLocation != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('current'),
//           position: currentLocation!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       );
//     }
//     if (pickupPoint != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('pickup'),
//           position: pickupPoint!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueGreen,
//           ),
//         ),
//       );
//     }
//     if (dropoffPoint != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('dropoff'),
//           position: dropoffPoint!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//     }

//     Set<Polyline> polylines = {};
//     if (routePolyline.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: const PolylineId('route'),
//           points: routePolyline,
//           color: primaryColor,
//           width: 5,
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: currentLocation ?? const LatLng(9.03, 38.74),
//             zoom: 13,
//           ),
//           markers: markers,
//           polylines: polylines,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           onMapCreated: onMapCreated,
//         ),
//         if (routeDistanceKm != null && routeDurationMin != null)
//           Positioned(
//             top: 50,
//             left: 60,
//             right: 60,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.4),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Distance: ${routeDistanceKm!.toStringAsFixed(2)} km",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Time: ${routeDurationMin!.round()} min",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  final LatLng? currentLocation;
  final LatLng? pickupPoint;
  final LatLng? dropoffPoint;
  final List<LatLng> routePolyline;
  final Color primaryColor;
  final double? routeDistanceKm;
  final double? routeDurationMin;
  final Function(GoogleMapController controller)? onMapCreated;

  const MapWidget({
    Key? key,
    this.mapController,
    required this.currentLocation,
    required this.pickupPoint,
    required this.dropoffPoint,
    required this.routePolyline,
    required this.primaryColor,
    this.routeDistanceKm,
    this.routeDurationMin,
    this.onMapCreated,
  }) : super(key: key);

  /// Helper: format duration
  String _formatDuration(double minutes) {
    if (minutes >= 60) {
      int hours = (minutes / 60).floor();
      int remainingMinutes = (minutes % 60).round();
      return remainingMinutes > 0
          ? "$hours h $remainingMinutes min"
          : "$hours h";
    } else {
      return "${minutes.round()} min";
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    if (pickupPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupPoint!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
    if (dropoffPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoffPoint!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    Set<Polyline> polylines = {};
    if (routePolyline.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePolyline,
          color: primaryColor,
          width: 5,
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation ?? const LatLng(9.03, 38.74),
            zoom: 13,
          ),
          markers: markers,
          polylines: polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: false, // ✅ Hide the compass
          onMapCreated: onMapCreated,
        ),
        if (routeDistanceKm != null && routeDurationMin != null)
          Positioned(
            top: 90,
            left: 50,
            right: 50,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Distance: ${routeDistanceKm!.toStringAsFixed(2)} km",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Time: ${_formatDuration(routeDurationMin!)}", // ✅ formatted time
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
