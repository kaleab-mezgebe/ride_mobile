import 'package:flutter/material.dart';
import '../models/ride_type.dart';

class RideTypeSelector extends StatelessWidget {
  final List<RideType> rideTypes;
  final String selectedType;
  final double? routeDistanceKm;
  final Function(RideType, double?) onSelect;
  final Color primaryColor;

  const RideTypeSelector({
    Key? key,
    required this.rideTypes,
    required this.selectedType,
    required this.routeDistanceKm,
    required this.onSelect,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rideTypes.length,
        itemBuilder: (context, index) {
          final ride = rideTypes[index];
          final isSelected = ride.type == selectedType;

          double? price;
          if (routeDistanceKm != null) {
            price = ride.basePrice + (routeDistanceKm! * ride.perKmPrice);
          }

          return GestureDetector(
            onTap: () => onSelect(ride, price),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? primaryColor.withOpacity(0.15)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ride.icon} ${ride.type}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryColor : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (price != null)
                    Text(
                      "Price: ${price.toStringAsFixed(2)} ETB",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primaryColor : Colors.black87,
                        fontSize: 14,
                      ),
                    )
                  else
                    const Text(
                      "Set route",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
