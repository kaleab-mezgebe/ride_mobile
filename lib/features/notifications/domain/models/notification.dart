class Driver {
  final String driverId;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String picture;
  final String carPicture;
  final String plateNumber;
  final double latitude;
  final double longitude;

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.picture,
    required this.carPicture,
    required this.plateNumber,
    required this.latitude,
    required this.longitude,
  });

  Driver copyWith({
    String? driverId,
    String? firstName,
    String? lastName,
    String? gender,
    String? phone,
    String? picture,
    String? carPicture,
    String? plateNumber,
    double? latitude,
    double? longitude,
  }) {
    return Driver(
      driverId: driverId ?? this.driverId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      carPicture: carPicture ?? this.carPicture,
      plateNumber: plateNumber ?? this.plateNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
