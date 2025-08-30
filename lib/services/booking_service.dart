import 'package:booking_stadium/firebase/firebase_service.dart';
import '../models/booking.dart';
import '../models/stadium.dart';

class BookingService {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API URL

  // Mock data for demonstration
  static List<Booking> _bookings = [];
  static List<Stadium> _stadiums = [];
  static int stadiumsLength = 0;

  // Initialize with mock data
  static void initializeMockData() {
    _stadiums = [];
    _bookings = [];
  }

  // Get all stadiums
  static Future<List<Stadium>> getStadiums(String uid) async {
    // Simulate API delay

    _stadiums = await FirebaseService.getAllStadiumsFromFirebase(uid);
    stadiumsLength = _stadiums.length;
    print(
      " [debug] booking_service : getStadiums() - _stadiums: ${_stadiums.length}",
    );
    return _stadiums;
  }

  static int getStadiumLength() {
    return stadiumsLength;
  }

  // Get stadium by ID
  static Future<Stadium?> getStadiumById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _stadiums.firstWhere((stadium) => stadium.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all bookings
  static Future<List<Booking>> getBookings(String uid) async {
    _bookings = await FirebaseService.getAllBookingsFromFirebase(uid);

    print(" [debug] booking in booking_service : ${_bookings}");
    return _bookings;
  }

  // Get bookings by stadium ID
  static Future<List<Booking>> getBookingsByStadium(String stadiumId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings
        .where((booking) => booking.stadiumId == stadiumId)
        .toList();
  }

  // Get bookings by date
  static Future<List<Booking>> getBookingsByDate(
    DateTime date,
    String uid,
  ) async {
    _bookings = await FirebaseService.getAllBookingsFromFirebase(uid);
    return _bookings
        .where(
          (booking) =>
              booking.date.year == date.year &&
              booking.date.month == date.month &&
              booking.date.day == date.day,
        )
        .toList();
  }

  // Create new booking
  static Future<Booking> createBooking(Booking booking, String uid) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newBooking = booking.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );

    FirebaseService.addBookingToFirestore(newBooking, uid);
    return newBooking;
  }

  // Update booking
  static Future<Booking?> updateBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      final updatedBooking = booking.copyWith(updatedAt: DateTime.now());
      _bookings[index] = updatedBooking;
      return updatedBooking;
    }
    return null;
  }

  // Delete booking
  static Future<bool> deleteBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings.removeAt(index);
      return true;
    }
    return false;
  }

  // Check availability for a specific date and time
  static Future<bool> checkAvailability(
    String stadiumId,
    DateTime date,
    String startTime,
    String endTime,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final conflictingBookings =
        _bookings
            .where(
              (booking) =>
                  booking.stadiumId == stadiumId &&
                  booking.date.year == date.year &&
                  booking.date.month == date.month &&
                  booking.date.day == date.day &&
                  booking.status != BookingStatus.cancelled &&
                  ((_compareTime(startTime, booking.startTime) >= 0 &&
                          _compareTime(startTime, booking.endTime) < 0) ||
                      (_compareTime(endTime, booking.startTime) > 0 &&
                          _compareTime(endTime, booking.endTime) <= 0) ||
                      (_compareTime(startTime, booking.startTime) <= 0 &&
                          _compareTime(endTime, booking.endTime) >= 0)),
            )
            .toList();

    return conflictingBookings.isEmpty;
  }

  // Helper method to compare time strings (HH:MM format)
  static int _compareTime(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');
    final minutes1 = int.parse(parts1[0]) * 60 + int.parse(parts1[1]);
    final minutes2 = int.parse(parts2[0]) * 60 + int.parse(parts2[1]);
    return minutes1.compareTo(minutes2);
  }

  // Get booking statistics
  static Future<Map<String, dynamic>> getBookingStats() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final totalBookings = _bookings.length;
    final confirmedBookings =
        _bookings.where((b) => b.status == BookingStatus.confirmed).length;
    final completedBookings =
        _bookings.where((b) => b.status == BookingStatus.completed).length;
    final cancelledBookings =
        _bookings.where((b) => b.status == BookingStatus.cancelled).length;
    final totalRevenue = _bookings
        .where((b) => b.isPaid)
        .fold(0.0, (sum, b) => sum + b.totalPrice);

    return {
      'totalBookings': totalBookings,
      'confirmedBookings': confirmedBookings,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'totalRevenue': totalRevenue,
      'averageRating':
          _stadiums.isNotEmpty
              ? _stadiums.map((s) => s.rating).reduce((a, b) => a + b) /
                  _stadiums.length
              : 0.0,
    };
  }
}
