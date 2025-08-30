// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get enableNotification =>
      'Enable notification 5 minutes before booking ends';

  @override
  String get testNotificationTitle => 'Test Notification';

  @override
  String get testNotificationBody =>
      'A notification will be sent 5 minutes before the booking ends!';

  @override
  String get notificationsEnabled => 'Notifications enabled!';

  @override
  String get notificationsDisabled => 'All notifications disabled!';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get profilePage => 'Settings/Profile Page';

  @override
  String get bookings => 'Bookings';

  @override
  String get noStadiumsAvailable => 'No stadiums available';

  @override
  String stadiumNumber(Object number) {
    return 'Stadium $number';
  }

  @override
  String get searchBookings => 'Search bookings...';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your search or filters';

  @override
  String get filterBookings => 'Filter Bookings';

  @override
  String get status => 'Status';

  @override
  String get allStatuses => 'All Statuses';

  @override
  String get stadium => 'Stadium';

  @override
  String get allStadiums => 'All Stadiums';

  @override
  String get todaySlots => 'Today\'s Slots';

  @override
  String get hours => 'hours';

  @override
  String get available => 'Available';

  @override
  String get bookedSlots => 'Booked Slots';

  @override
  String get noBookingsForDay => 'No bookings for this day';

  @override
  String get newBooking => 'New Booking';

  @override
  String get tryAgain => 'Try Again';

  @override
  String monthlyRevenueSummary(Object revenue) {
    return 'Total revenue for this month: $revenue EGP';
  }

  @override
  String revenue(Object revenue) {
    return 'Revenue: $revenue EGP';
  }

  @override
  String get start => 'Let\'s Start!';

  @override
  String get stadiumCount => 'How many stadiums do you have?';

  @override
  String get pleaseEnterStadiumCount => 'Please enter the number of stadiums';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get hourlyPrice => 'Hourly Price';

  @override
  String get pleaseEnterHourlyPrice => 'Please enter the hourly price';

  @override
  String get openHour => 'Open Hour';

  @override
  String get selectOpenHour => 'Select open hour';

  @override
  String get closeHour => 'Close Hour';

  @override
  String get selectCloseHour => 'Select close hour';

  @override
  String get revenues => 'Revenues';
}
