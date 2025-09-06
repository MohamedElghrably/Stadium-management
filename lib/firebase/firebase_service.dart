import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/stadium.dart';
import '../models/user.dart';

class FirebaseService {
  /// Static helper for Booking collection
  static CollectionReference<UserModel> userCollection() {
    return FirebaseFirestore.instance
        .collection('user')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static CollectionReference<Booking> bookingCollection(String uid) {
    return userCollection()
        .doc(uid)
        .collection('bookings')
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) => Booking.fromJson(snapshot.data()!),
          toFirestore: (booking, _) => booking.toJson(),
        );
  }

  /// Static helper for Stadium collection
  static CollectionReference<Stadium> stadiumCollection(String uid) {
    return userCollection()
        .doc(uid)
        .collection('stadiums')
        .withConverter<Stadium>(
          fromFirestore: (snapshot, _) => Stadium.fromJson(snapshot.data()!),
          toFirestore: (stadium, _) => stadium.toJson(),
        );
  }

  /// Add a Booking to Firestore
  static Future<void> addBookingToFirestore(Booking booking, String uid) {
    CollectionReference<Booking> collection = bookingCollection(uid);
    DocumentReference<Booking> doc = collection.doc();
    booking.id = doc.id;
    return doc.set(booking);
  }

  /// Get all Bookings from Firestore
  static Future<List<Booking>> getAllBookingsFromFirebase(String uid) async {
    CollectionReference<Booking> collection = bookingCollection(uid);
    QuerySnapshot<Booking> querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Add a Stadium to Firestore
  static Future<void> addStadiumToFirestore(Stadium stadium, String uid) {
    CollectionReference<Stadium> collection = stadiumCollection(uid);
    DocumentReference<Stadium> doc = collection.doc();
    stadium.id = doc.id;
    return doc.set(stadium);
  }

  /// Get all Stadiums from Firestore
  static Future<List<Stadium>> getAllStadiumsFromFirebase(String uid) async {
    CollectionReference<Stadium> collection = stadiumCollection(uid);
    QuerySnapshot<Stadium> querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> addUsertoFirestore(UserModel user) async {
    CollectionReference<UserModel> collection = userCollection();
    DocumentReference<UserModel> doc = collection.doc(user.id);
    return doc.set(user);
  }

  static Future<List<UserModel>> getAllUsersFromFirebase() async {
    CollectionReference<UserModel> collection = userCollection();
    QuerySnapshot<UserModel> querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<UserModel?> getUserByUid(String uid) async {
    CollectionReference<UserModel> collection = userCollection();
    print(" [debug] Fetching user from collection: ${collection.path}");
    DocumentReference<UserModel> doc = collection.doc(uid);
    DocumentSnapshot<UserModel> snapshot = await doc.get();
    if (!snapshot.exists) {
      print(" [debug] No document found for uid: $uid");
      return null;
    }
    return snapshot.data();
  }

  static Future<List<String>> getAllStadiumNamesFromFirebase() async {
    final snapshot = await userCollection().get();

    return snapshot.docs
        .map((doc) => doc.data().stadiumName) // already typed
        .where((name) => name.isNotEmpty)
        .toList();
  }
}
