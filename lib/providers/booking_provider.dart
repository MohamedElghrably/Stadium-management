import 'package:booking_stadium/services/stadium_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/stadium.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  List<Stadium> _stadiums = [];
  List<Booking> _bookings = [];
  TimeOfDay openHour = TimeOfDay(hour: 8, minute: 0); // Default value
  TimeOfDay closeHour = TimeOfDay(hour: 22, minute: 0);
  int hourlyPrice = 0;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _stats = {};
  bool notificationsEnabled = false;

  // Getters
  List<Stadium> get stadiums => _stadiums;
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get stats => _stats;

  // Initialize the provider
  Future<void> initialize(String uid) async {
    // BookingService.initializeMockData();
    await loadStadiums(uid);
    await loadBookings(uid);
    await loadStats();
    openHour =
        _stadiums.isNotEmpty
            ? _stadiums.first.openHour
            : TimeOfDay(hour: 8, minute: 0);
    closeHour =
        _stadiums.isNotEmpty
            ? _stadiums.first.closeHour
            : TimeOfDay(hour: 22, minute: 0);
    hourlyPrice =
        _stadiums.isNotEmpty ? _stadiums.first.pricePerHour.toInt() : 0;
    notifyListeners();
  }

  // Load all stadiums
  Future<void> loadStadiums(String uid) async {
    _setLoading(true);
    try {
      _stadiums = await BookingService.getStadiums(uid);
      _error = null;
    } catch (e) {
      _error = 'Failed to load stadiums: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Load all bookings
  Future<void> loadBookings(String uid) async {
    _setLoading(true);
    try {
      _bookings = await BookingService.getBookings(uid);
      print(" [debug] bookings in booking_provider ${_bookings.length}");
      _error = null;
    } catch (e) {
      _error = 'Failed to load bookings: $e';
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Load booking statistics
  Future<void> loadStats() async {
    try {
      _stats = await BookingService.getBookingStats();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load statistics: $e';
      notifyListeners();
    }
  }

  // Get stadium by ID
  Stadium? getStadiumById(String id) {
    try {
      return _stadiums.firstWhere((stadium) => stadium.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Stadium>? getStadiums() {
    try {
      return _stadiums;
    } catch (e) {
      return null;
    }
  }

  // Get bookings by stadium ID
  List<Booking> getBookingsByStadium(String stadiumId) {
    return _bookings
        .where((booking) => booking.stadiumId == stadiumId)
        .toList();
  }

  // Get bookings by date
  List<Booking> getBookingsByDate(DateTime date) {
    return _bookings
        .where(
          (booking) =>
              booking.date.year == date.year &&
              booking.date.month == date.month &&
              booking.date.day == date.day,
        )
        .toList();
  }

  // Get bookings by status
  List<Booking> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  // Check for booking conflict
  bool hasBookingConflict(Booking newBooking) {
    return _bookings.any((booking) {
      if (booking.stadiumId != newBooking.stadiumId) return false;
      if (booking.date.year != newBooking.date.year ||
          booking.date.month != newBooking.date.month ||
          booking.date.day != newBooking.date.day)
        return false;
      // Check for time overlap
      final newStart = _parseTime(newBooking.startTime);
      final newEnd = _parseTime(newBooking.endTime);
      final existStart = _parseTime(booking.startTime);
      final existEnd = _parseTime(booking.endTime);
      return newStart.isBefore(existEnd) && newEnd.isAfter(existStart);
    });
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(2025, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  // Create new booking
  Future<bool> createBooking(Booking booking, String uid) async {
    if (hasBookingConflict(booking)) {
      _error = 'محجوز بالفعل';
      notifyListeners();
      return false;
    }
    _setLoading(true);
    try {
      final newBooking = await BookingService.createBooking(booking, uid);
      _bookings.add(newBooking);
      await loadStats(); // Refresh stats
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create booking: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update booking
  Future<bool> updateBooking(Booking booking) async {
    _setLoading(true);
    try {
      final updatedBooking = await BookingService.updateBooking(booking);
      if (updatedBooking != null) {
        final index = _bookings.indexWhere((b) => b.id == booking.id);
        if (index != -1) {
          _bookings[index] = updatedBooking;
          await loadStats(); // Refresh stats
          _error = null;
          notifyListeners();
          return true;
        }
      }
      _error = 'Booking not found';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to update booking: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete booking
  Future<bool> deleteBooking(String bookingId) async {
    _setLoading(true);
    try {
      final success = await BookingService.deleteBooking(bookingId);
      if (success) {
        _bookings.removeWhere((booking) => booking.id == bookingId);
        await loadStats(); // Refresh stats
        _error = null;
        notifyListeners();
        return true;
      }
      _error = 'Failed to delete booking';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to delete booking: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check availability
  Future<bool> checkAvailability(
    String stadiumId,
    DateTime date,
    String startTime,
    String endTime,
  ) async {
    try {
      return await BookingService.checkAvailability(
        stadiumId,
        date,
        startTime,
        endTime,
      );
    } catch (e) {
      _error = 'Failed to check availability: $e';
      notifyListeners();
      return false;
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    final updatedBooking = booking.copyWith(status: status);
    return await updateBooking(updatedBooking);
  }

  // Mark booking as paid
  Future<bool> markBookingAsPaid(String bookingId) async {
    final booking = _bookings.firstWhere((b) => b.id == bookingId);
    final updatedBooking = booking.copyWith(isPaid: true);
    return await updateBooking(updatedBooking);
  }

  bool setOpenHour(TimeOfDay openHour) {
    this.openHour = openHour;
    notifyListeners();
    return true;
  }

  bool setCloseHour(TimeOfDay closeHour) {
    this.closeHour = closeHour;
    notifyListeners();
    return true;
  }

  void setHourlyPrice(int price) {
    hourlyPrice = price;
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  // Get today's bookings
  // List<Booking> getTodayBookings() {
  //   final today = DateTime.now();
  //   return getBookingsByDate(today);
  // }

  // Get upcoming bookings
  List<Booking> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.date.isAfter(now) &&
              booking.status != BookingStatus.cancelled,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get revenue for a specific period
  double getRevenueForPeriod(DateTime startDate, DateTime endDate) {
    return _bookings
        .where(
          (booking) =>
              booking.date.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              booking.date.isBefore(endDate.add(const Duration(days: 1))) &&
              booking.isPaid,
        )
        .fold(0.0, (sum, booking) => sum + booking.totalPrice);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addStadium(Stadium stadium, String uid) {
    StadiumService.addStadium(stadium, uid);
    print(" [debug] stadium ${stadium.name} added");
    notifyListeners();
  }
}
