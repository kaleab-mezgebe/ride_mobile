// class UserModel {
//   final String phone;
//   final String firstName;
//   final String lastName;
//   final String email;

//   UserModel({
//     required this.phone,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       phone: json['phone'] ?? '',
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       email: json['email'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'phone': phone,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//     };
//   }
// }

class UserModel {
  final int id; // added
  final String phone;
  final String firstName;
  final String lastName;
  final String email;

  UserModel({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      phone: json['phoneNumber'] ?? '', // match backend field
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'firstName': firstName, 'lastName': lastName, 'email': email};
  }

  // copyWith for updating specific fields easily
  UserModel copyWith({
    int? id,
    String? phone,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }
}
