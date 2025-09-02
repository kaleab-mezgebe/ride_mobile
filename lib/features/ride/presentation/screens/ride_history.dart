// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../core/services/api_service.dart';

// class RideHistoryScreen extends StatefulWidget {
//   const RideHistoryScreen({super.key});

//   @override
//   State<RideHistoryScreen> createState() => _RideHistoryScreenState();
// }

// class _RideHistoryScreenState extends State<RideHistoryScreen> {
//   List<Map<String, dynamic>> rideHistory = [];
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     _loadRideHistory();
//   }

//   Future<void> _loadRideHistory() async {
//     final history = await ApiService().getRideHistory();
//     setState(() {
//       rideHistory = history;
//       isLoading = false;
//     });
//   }

//   Future<void> _deleteRide(int index) async {
//     final ride = rideHistory[index];
//     try {
//       await ApiService().deleteRide(index); // delete from API/Service
//       setState(() => rideHistory.removeAt(index));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("${ride['pickup']} → ${ride['dropoff']} deleted"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Failed to delete ride: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;

//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Ride History'),
//           backgroundColor: primaryColor,
//           centerTitle: true,
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Ride History',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         elevation: 2,
//       ),
//       body:
//           rideHistory.isEmpty
//               ? const Center(
//                 child: Text(
//                   "No ride history yet",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//               : ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: rideHistory.length,
//                 itemBuilder: (context, index) {
//                   final ride = rideHistory[index];
//                   final bool completed = ride['status'] == 'Completed';

//                   // Ensure date is a DateTime object
//                   final rideDate =
//                       ride['date'] is DateTime
//                           ? ride['date']
//                           : DateTime.tryParse(ride['date'].toString()) ??
//                               DateTime.now();

//                   return Dismissible(
//                     key: Key(
//                       ride['pickup'] + ride['dropoff'] + index.toString(),
//                     ),
//                     direction: DismissDirection.horizontal,
//                     background: _buildSwipeBackground(Alignment.centerLeft),
//                     secondaryBackground: _buildSwipeBackground(
//                       Alignment.centerRight,
//                     ),
//                     onDismissed: (_) => _deleteRide(index),
//                     child: Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(12),
//                         leading: CircleAvatar(
//                           backgroundColor:
//                               completed
//                                   ? primaryColor.withOpacity(0.7)
//                                   : Colors.red.shade400,
//                           child: Icon(
//                             completed ? Icons.check : Icons.close,
//                             color: Colors.white,
//                           ),
//                         ),
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${ride['pickup']} → ${ride['dropoff']}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               DateFormat(
//                                 'EEE, dd MMM yyyy – hh:mm a',
//                               ).format(rideDate),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             'Fare: ${ride['fare'].toStringAsFixed(2)} ETB',
//                             style: const TextStyle(
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 completed
//                                     ? primaryColor.withOpacity(0.1)
//                                     : Colors.red.shade100,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             ride['status'],
//                             style: TextStyle(
//                               color: completed ? primaryColor : Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }

//   Widget _buildSwipeBackground(Alignment alignment) {
//     return Container(
//       alignment: alignment,
//       color: Colors.red,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: const Icon(Icons.delete, color: Colors.white),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart';

class RideHistoryScreen extends StatefulWidget {
  final String phone; // ✅ pass phone from navigation

  const RideHistoryScreen({super.key, required this.phone});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> rideHistory = [];

  @override
  void initState() {
    super.initState();
    _loadRideHistory();
  }

  Future<void> _loadRideHistory() async {
    try {
      final history = await ApiService().getRideHistory(
        widget.phone,
      ); // ✅ pass phone
      setState(() {
        rideHistory = history;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load ride history: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ride History")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : rideHistory.isEmpty
              ? const Center(child: Text("No rides found."))
              : ListView.builder(
                itemCount: rideHistory.length,
                itemBuilder: (context, index) {
                  final ride = rideHistory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.local_taxi, color: Colors.blue),
                      title: Text("From: ${ride['pickup'] ?? 'Unknown'}"),
                      subtitle: Text("To: ${ride['destination'] ?? 'Unknown'}"),
                      trailing: Text(
                        ride['date'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
