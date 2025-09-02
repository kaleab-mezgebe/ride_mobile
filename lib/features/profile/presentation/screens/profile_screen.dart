// import 'package:flutter/material.dart';
// import '../../../auth/domain/models/user.dart';
// import '../../../../core/services/api_service.dart';

// class ProfilePage extends StatefulWidget {
//   final String token; // store token properly

//   const ProfilePage({super.key, required this.token});
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController emailController;
//   String phoneNumber = "";
//   bool isEditing = false;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     firstNameController = TextEditingController();
//     lastNameController = TextEditingController();
//     emailController = TextEditingController();
//     _fetchProfile();
//   }

//   Future<void> _fetchProfile() async {
//     // Pass token safely using !
//     final profile = await ApiService().getUserProfile(widget.token);
//     if (profile != null) {
//       firstNameController.text = profile.firstName;
//       lastNameController.text = profile.lastName;
//       emailController.text = profile.email;
//       phoneNumber = profile.phone;
//     }
//     setState(() => _loading = false);
//   }

//   Future<void> _saveProfile() async {
//     if (firstNameController.text.trim().isEmpty ||
//         lastNameController.text.trim().isEmpty ||
//         emailController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("All fields are required")));
//       return;
//     }

//     setState(() => _loading = true);
//     final ok = await ApiService().updateProfile(
//       UserModel(
//         phone: phoneNumber,
//         firstName: firstNameController.text.trim(),
//         lastName: lastNameController.text.trim(),
//         email: emailController.text.trim(),
//       ),
//     );

//     setState(() => _loading = false);

//     if (ok) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully")),
//       );
//       setState(() => isEditing = false);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to save profile")));
//     }
//   }

//   String _initials() {
//     final f = firstNameController.text.trim();
//     final l = lastNameController.text.trim();
//     final fi = f.isNotEmpty ? f[0].toUpperCase() : "";
//     final li = l.isNotEmpty ? l[0].toUpperCase() : "";
//     return (fi + li).isEmpty ? "?" : fi + li;
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).primaryColor;
//     final surfaceColor = Theme.of(context).colorScheme.surface;
//     final backgroundColor = Theme.of(context).colorScheme.background;

//     if (_loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: primaryColor,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundColor: primaryColor,
//                 child: Text(
//                   _initials(),
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 phoneNumber,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildEditableField(
//                 "First Name",
//                 firstNameController,
//                 primaryColor,
//                 surfaceColor,
//               ),
//               _buildEditableField(
//                 "Last Name",
//                 lastNameController,
//                 primaryColor,
//                 surfaceColor,
//               ),
//               _buildEditableField(
//                 "Email",
//                 emailController,
//                 primaryColor,
//                 surfaceColor,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _loading ? null : _saveProfile,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         backgroundColor: primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child:
//                           _loading
//                               ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                               : const Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => setState(() => isEditing = !isEditing),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         backgroundColor: primaryColor.withOpacity(0.7),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         isEditing ? "Cancel" : "Edit",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableField(
//     String label,
//     TextEditingController controller,
//     Color primaryColor,
//     Color fillColor, {
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         controller: controller,
//         readOnly: !isEditing,
//         textCapitalization: TextCapitalization.words,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: fillColor,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: primaryColor, width: 2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/domain/models/user.dart';
import '../../../auth/presentation/controllers/user_controller.dart';
import '../../../../core/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String token; // keep token if needed for future API calls

  const ProfilePage({super.key, required this.token});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  String phoneNumber = "";
  int id = 0;
  bool isEditing = false;
  bool _loading = true;

  final userController = Get.find<UserController>(); // GetX global controller

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();

    _loadUserFromGetX();
  }

  void _loadUserFromGetX() {
    final user = userController.currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      phoneNumber = user.phone;
      id = user.id;

      // globally saved phone number
    }
    setState(() => _loading = false);
  }

  Future<void> _saveProfile() async {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }

    final currentUser = userController.currentUser.value;
    if (currentUser == null) return;

    setState(() => _loading = true);

    // Send update request to backend using customerId
    final updatedUser = UserModel(
      phone: currentUser.phone,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      id: currentUser.id,
    );

    final result = await ApiService().updateProfile(
      updatedUser,
      currentUser.id,
    ); // pass id

    setState(() => _loading = false);

    if (result != null) {
      // Update GetX global user
      userController.setUser(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully")),
      );
      setState(() => isEditing = false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save profile")));
    }
  }

  String _initials() {
    final f = firstNameController.text.trim();
    final l = lastNameController.text.trim();
    final fi = f.isNotEmpty ? f[0].toUpperCase() : "";
    final li = l.isNotEmpty ? l[0].toUpperCase() : "";
    return (fi + li).isEmpty ? "?" : fi + li;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final backgroundColor = Theme.of(context).colorScheme.background;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor,
                child: Text(
                  _initials(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                "First Name",
                firstNameController,
                primaryColor,
                surfaceColor,
              ),
              _buildEditableField(
                "Last Name",
                lastNameController,
                primaryColor,
                surfaceColor,
              ),
              _buildEditableField(
                "Email",
                emailController,
                primaryColor,
                surfaceColor,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _loading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isEditing = !isEditing),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: primaryColor.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? "Cancel" : "Edit",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    Color primaryColor,
    Color fillColor, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: !isEditing,
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
