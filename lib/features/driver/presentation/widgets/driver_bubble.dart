import 'package:flutter/material.dart';

class DriverBubble extends StatelessWidget {
  final String driverPicture;
  final VoidCallback onTap;

  const DriverBubble({
    Key? key,
    required this.driverPicture,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      left: 16,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(driverPicture),
          ),
        ),
      ),
    );
  }
}
