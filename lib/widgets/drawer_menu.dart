import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final Color primaryColor;
  final bool darkMode;
  final VoidCallback onRideHistory;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final VoidCallback onLogout;
  final ValueChanged<bool> onDarkModeToggle;

  const DrawerMenu({
    Key? key,
    required this.primaryColor,
    required this.darkMode,
    required this.onRideHistory,
    required this.onNotifications,
    required this.onProfile,
    required this.onLogout,
    required this.onDarkModeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 16),
                Text(
                  "Welcome, User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.history, color: primaryColor),
            title: const Text("Ride History"),
            onTap: onRideHistory,
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: primaryColor),
            title: const Text("Notifications"),
            onTap: onNotifications,
          ),
          ListTile(
            leading: Icon(Icons.person, color: primaryColor),
            title: const Text("Profile"),
            onTap: onProfile,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: darkMode,
            onChanged: onDarkModeToggle,
            secondary: const Icon(Icons.brightness_6),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: primaryColor),
            title: const Text("Logout"),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
