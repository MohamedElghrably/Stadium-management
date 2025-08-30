import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @enableNotification.
  ///
  /// In en, this message translates to:
  /// **'Enable notification 5 minutes before booking ends'**
  String get enableNotification;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'A notification will be sent 5 minutes before the booking ends!'**
  String get testNotificationBody;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled!'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'All notifications disabled!'**
  String get notificationsDisabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @profilePage.
  ///
  /// In en, this message translates to:
  /// **'Settings/Profile Page'**
  String get profilePage;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @noStadiumsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stadiums available'**
  String get noStadiumsAvailable;

  /// No description provided for @stadiumNumber.
  ///
  /// In en, this message translates to:
  /// **'Stadium {number}'**
  String stadiumNumber(Object number);

  /// No description provided for @searchBookings.
  ///
  /// In en, this message translates to:
  /// **'Search bookings...'**
  String get searchBookings;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingFilters;

  /// No description provided for @filterBookings.
  ///
  /// In en, this message translates to:
  /// **'Filter Bookings'**
  String get filterBookings;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @stadium.
  ///
  /// In en, this message translates to:
  /// **'Stadium'**
  String get stadium;

  /// No description provided for @allStadiums.
  ///
  /// In en, this message translates to:
  /// **'All Stadiums'**
  String get allStadiums;

  /// No description provided for @todaySlots.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Slots'**
  String get todaySlots;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @bookedSlots.
  ///
  /// In en, this message translates to:
  /// **'Booked Slots'**
  String get bookedSlots;

  /// No description provided for @noBookingsForDay.
  ///
  /// In en, this message translates to:
  /// **'No bookings for this day'**
  String get noBookingsForDay;

  /// No description provided for @newBooking.
  ///
  /// In en, this message translates to:
  /// **'New Booking'**
  String get newBooking;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @monthlyRevenueSummary.
  ///
  /// In en, this message translates to:
  /// **'Total revenue for this month: {revenue} EGP'**
  String monthlyRevenueSummary(Object revenue);

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue: {revenue} EGP'**
  String revenue(Object revenue);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start!'**
  String get start;

  /// No description provided for @stadiumCount.
  ///
  /// In en, this message translates to:
  /// **'How many stadiums do you have?'**
  String get stadiumCount;

  /// No description provided for @pleaseEnterStadiumCount.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of stadiums'**
  String get pleaseEnterStadiumCount;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @hourlyPrice.
  ///
  /// In en, this message translates to:
  /// **'Hourly Price'**
  String get hourlyPrice;

  /// No description provided for @pleaseEnterHourlyPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the hourly price'**
  String get pleaseEnterHourlyPrice;

  /// No description provided for @openHour.
  ///
  /// In en, this message translates to:
  /// **'Open Hour'**
  String get openHour;

  /// No description provided for @selectOpenHour.
  ///
  /// In en, this message translates to:
  /// **'Select open hour'**
  String get selectOpenHour;

  /// No description provided for @closeHour.
  ///
  /// In en, this message translates to:
  /// **'Close Hour'**
  String get closeHour;

  /// No description provided for @selectCloseHour.
  ///
  /// In en, this message translates to:
  /// **'Select close hour'**
  String get selectCloseHour;

  /// No description provided for @revenues.
  ///
  /// In en, this message translates to:
  /// **'Revenues'**
  String get revenues;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
