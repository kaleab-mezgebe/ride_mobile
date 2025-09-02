import 'package:get/get.dart';
import '../../domain/models/user.dart';

class UserController extends GetxController {
  // Rxn allows null initially
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // Getter
  UserModel? get user => currentUser.value;

  // Set user
  void setUser(UserModel user) {
    currentUser.value = user;
  }

  // Clear user (logout)
  void clearUser() {
    currentUser.value = null;
  }
}
