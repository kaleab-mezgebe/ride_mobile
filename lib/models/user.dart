class UserModel {
  final String phone;
  final String firstName;
  final String lastName;
  final String email;

  UserModel({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
