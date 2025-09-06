import 'package:booking_stadium/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateUser(UserModel? user) {
    currentUser = user;
    print(" [debug] user provider = ${currentUser?.phone}");
    notifyListeners();
  }

  void udateUserType(String userType) {
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(userType: userType);
      notifyListeners();
      print(" [debug] user type updated to $userType");
    }
  }
}
