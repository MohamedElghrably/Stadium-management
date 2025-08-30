import 'package:booking_stadium/firebase/firebase_service.dart';
import 'package:booking_stadium/models/stadium.dart';

class StadiumService {
  static Future<void> addStadium(Stadium stadium, String uid) async {
    try {
      await FirebaseService.addStadiumToFirestore(stadium, uid);
      print(" [debug] Stadium added!");
    } catch (e) {
      print(" [debug] Failed to add stadium: $e");
    }
  }

  static Future<void> getStadiums(String uid) async {
    try {
      await FirebaseService.getAllStadiumsFromFirebase(uid);
      print(" [debug] Stadium added!");
    } catch (e) {
      print(" [debug] Failed to get stadium: $e");
    }
  }
}
