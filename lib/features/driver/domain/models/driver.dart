import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverModel {
  final String driverId;
  final String firstName;
  final String lastName;
  final String gender;
  final String phoneNumber; // new field
  final String picture;
  final String carPicture;
  final String plateNumber;
  LatLng latLng;

  DriverModel({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber, // include in constructor
    required this.picture,
    required this.carPicture,
    required this.plateNumber,
    required this.latLng,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      driverId: map['driverId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'] ?? '', // handle null
      picture: map['picture'],
      carPicture: map['carPicture'],
      plateNumber: map['plateNumber'],
      latLng: map['latLng'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phoneNumber': phoneNumber, // include in map
      'picture': picture,
      'carPicture': carPicture,
      'plateNumber': plateNumber,
      'latLng': latLng,
    };
  }
}
