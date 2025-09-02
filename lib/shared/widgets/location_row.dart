import 'package:flutter/material.dart';

class LocationRow extends StatelessWidget {
  final String label;
  final String? location;
  final bool isPickup;
  final VoidCallback onTap;
  final Color primaryColor;

  const LocationRow({
    Key? key,
    required this.label,
    required this.location,
    required this.isPickup,
    required this.onTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isPickup ? Icons.my_location : Icons.location_on,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  location ?? "Tap to select",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit, size: 22, color: Colors.grey),
        ],
      ),
    );
  }
}
