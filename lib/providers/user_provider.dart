import 'package:booking_stadium/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateUser(UserModel? user) {
    currentUser = user;
    print(" [debug] user provider = ${currentUser?.phone}");
    notifyListeners();
  }
}
