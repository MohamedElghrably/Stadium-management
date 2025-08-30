import 'package:booking_stadium/firebase/firebase_service.dart';
import 'package:booking_stadium/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class RegisterService {
  static String _verificationId = '';
  static bool _codeSent = false;
  static List<UserModel> users = [];

  static Future<bool> sendOTP(String phoneNumber) async {
    final completer = Completer<bool>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // print('تم التحقق التلقائي');
        // print(" [debug]  credential: $credential");
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // print('فشل ارسال رمز التحقق: ${e.message}');
        // print('الكود: ${e.code}');
        if (!completer.isCompleted) completer.complete(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        // print('تم إرسال الكود بنجاح');
        _verificationId = verificationId;
        if (!completer.isCompleted) completer.complete(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // print('انتهت مهلة التحقق التلقائي');
        _verificationId = verificationId;
      },
    );
    return completer.future;
  }

  static Future<bool> verifyOTP(String otp) async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(_credential);

      // print('Phone number verified and user signed in!');
      // print(" [debug] credentials $_credential");
      return true;
    } catch (e) {
      // print('OTP verification failed: $e');
      return false;
    }
  }

  static Future<void> addingNewUser(String username, String phone) async {
    User? currentUser = getCurrentUser();
    UserModel user = UserModel(
      id: currentUser!.uid,
      username: username,
      phone: phone,
    );
    try {
      await FirebaseService.addUsertoFirestore(user);
      // print(" [debug] user added");
    } catch (e) {
      // print(" [debug] Failed to add stadium: $e");
    }
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();
  static User? getCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      print(" [debug] current user = ${FirebaseAuth.instance.currentUser}");
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }

  static Future<UserModel?> getCurrentUserModel() async {
    User? user = getCurrentUser();
    print(" [debug] uid register_service = ${user!.uid}");
    UserModel? userModel;
    userModel = await FirebaseService.getUserByUid(user.uid);
    print(" [debug] userModel register_service = $userModel");
    return userModel;
  }
}
