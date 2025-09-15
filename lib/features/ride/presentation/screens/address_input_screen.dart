import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nyat_ride_system/core/constants/flutter_maps/secrets.dart';

class GoogleAddressInputScreen extends StatefulWidget {
  const GoogleAddressInputScreen({super.key, required Map places});

  @override
  State<GoogleAddressInputScreen> createState() =>
      _GoogleAddressInputScreenState();
}

class _GoogleAddressInputScreenState extends State<GoogleAddressInputScreen> {
  final TextEditingController _searchController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _selectedPoint;
  String? _selectedAddress;
  List<Map<String, dynamic>> _searchResults = [];

  final String googleApiKey = Secrets.API_KEY;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is required")),
      );
      return;
    }

    // Get current position
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(pos.latitude, pos.longitude);
      _selectedPoint = _currentLocation;
    });

    // Move camera to current location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );
    }

    // Get address of current location
    if (_currentLocation != null) {
      String address = await _getAddressFromLatLng(_currentLocation!);
      setState(() {
        _selectedAddress = address;
        _searchController.text = address;
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    if (googleApiKey.isEmpty) return;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&types=geocode',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List;
      setState(() {
        _searchResults =
            predictions
                .map(
                  (p) => {'name': p['description'], 'place_id': p['place_id']},
                )
                .toList();
      });
    }
  }

  Future<LatLng?> _getLatLngFromPlaceId(String placeId) async {
    if (googleApiKey.isEmpty) return null;
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }
    return null;
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    try {
      final url = Uri.parse(
        'https://photon.komoot.io/reverse?lat=${point.latitude}&lon=${point.longitude}&lang=en',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        if (features.isNotEmpty) {
          final props = features[0]['properties'];
          final nameParts = [
            if (props['name'] != null) props['name'],
            if (props['city'] != null) props['city'],
            if (props['country'] != null) props['country'],
          ];

          final rawAddress = nameParts.join(', ');
          final filteredAddress = rawAddress.replaceAll(
            RegExp(r'[^a-zA-Z0-9 ,.]'),
            '',
          );
          return filteredAddress.isNotEmpty
              ? filteredAddress
              : "Selected Location";
        }
      }
    } catch (_) {}
    return "Selected Location";
  }

  void _confirmLocation() {
    if (_selectedPoint != null && _selectedAddress != null) {
      Navigator.pop(context, {
        'name': _selectedAddress,
        'latLng': _selectedPoint,
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a location")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for an address",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchResults.clear());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) _searchLocation(query);
              },
            ),
          ),
          // Search results
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(item['name']),
                    onTap: () async {
                      LatLng? point = await _getLatLngFromPlaceId(
                        item['place_id'],
                      );
                      if (point != null && _mapController != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newLatLngZoom(point, 16),
                        );
                        final address = await _getAddressFromLatLng(point);
                        setState(() {
                          _selectedPoint = point;
                          _selectedAddress = address;
                          _searchController.text = address;
                          _searchResults.clear();
                        });
                      }
                    },
                  );
                },
              ),
            ),
          // Map
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? const LatLng(13.4967, 39.4750),
                    zoom: 16,
                  ),
                  myLocationEnabled: true, // hide blue dot
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onCameraMove: (position) {
                    _selectedPoint = position.target;
                  },
                  onCameraIdle: () async {
                    if (_selectedPoint != null) {
                      final address = await _getAddressFromLatLng(
                        _selectedPoint!,
                      );
                      if (!mounted) return;
                      setState(() {
                        _selectedAddress = address;
                        _searchController.text = address;
                      });
                    }
                  },
                ),
                // Centered custom marker
                if (_currentLocation != null)
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 24,
                    top: MediaQuery.of(context).size.height / 2 - 60,
                    child: Image.asset(
                      'assets/images/marker.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
