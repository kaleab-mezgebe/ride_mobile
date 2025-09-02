import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/widgets/map_widget.dart';

class DriverMap extends StatelessWidget {
  final GoogleMapController? mapController;
  final LatLng? driverLocation;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final List<LatLng> routePolyline;
  final double? distanceKm;
  final double? durationMin;
  final Color primaryColor;
  final void Function(GoogleMapController) onMapCreated;

  const DriverMap({
    Key? key,
    required this.mapController,
    required this.driverLocation,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.routePolyline,
    required this.distanceKm,
    required this.durationMin,
    required this.primaryColor,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (driverLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return MapWidget(
      mapController: mapController,
      currentLocation: driverLocation,
      driverLocation: driverLocation,
      pickupPoint: pickupLocation,
      dropoffPoint: dropoffLocation,
      routePolyline: routePolyline,
      primaryColor: primaryColor,
      routeDistanceKm: distanceKm,
      routeDurationMin: durationMin,
      onMapCreated: onMapCreated,
    );
  }
}
