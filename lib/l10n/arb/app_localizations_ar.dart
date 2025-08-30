// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get enableNotification => 'تفعيل تنبيه قبل نهاية الحجز بـ 5 دقائق';

  @override
  String get testNotificationTitle => 'تنبيه تجربة';

  @override
  String get testNotificationBody =>
      'سيتم إرسال تنبيه قبل نهاية الحجز بـ 5 دقائق!';

  @override
  String get notificationsEnabled => 'تم تفعيل التنبيهات!';

  @override
  String get notificationsDisabled => 'تم إيقاف جميع التنبيهات!';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get profilePage => 'صفحة الإعدادات/الملف الشخصي';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get noStadiumsAvailable => 'لا يوجد ملاعب متاحة';

  @override
  String stadiumNumber(Object number) {
    return 'ملعب $number';
  }

  @override
  String get searchBookings => 'ابحث في الحجوزات...';

  @override
  String get noBookingsFound => 'لا توجد حجوزات';

  @override
  String get tryAdjustingFilters => 'حاول تعديل البحث أو الفلاتر';

  @override
  String get filterBookings => 'تصفية الحجوزات';

  @override
  String get status => 'الحالة';

  @override
  String get allStatuses => 'كل الحالات';

  @override
  String get stadium => 'الملعب';

  @override
  String get allStadiums => 'كل الملاعب';

  @override
  String get todaySlots => 'مواعيد اليوم';

  @override
  String get hours => 'ساعة';

  @override
  String get available => 'فاضي';

  @override
  String get bookedSlots => 'الحجوزات المحجوزة';

  @override
  String get noBookingsForDay => 'لا يوجد حجوزات لهذا اليوم';

  @override
  String get newBooking => 'حجز جديد';

  @override
  String get tryAgain => 'حاول تاني';

  @override
  String monthlyRevenueSummary(Object revenue) {
    return 'إجمالي الإيرادات لهذا الشهر: $revenue جنيه';
  }

  @override
  String revenue(Object revenue) {
    return 'الإيراد: $revenue جنيه';
  }

  @override
  String get start => 'يلا بينا نبدأ!';

  @override
  String get stadiumCount => 'عندك كام ملعب؟';

  @override
  String get pleaseEnterStadiumCount => 'من فضلك ادخل عدد الملاعب';

  @override
  String get enterValidNumber => 'اكتب رقم صحيح';

  @override
  String get hourlyPrice => 'سعر الساعة';

  @override
  String get pleaseEnterHourlyPrice => 'من فضلك ادخل سعر الساعة';

  @override
  String get openHour => 'ساعة الفتح';

  @override
  String get selectOpenHour => 'اختار ساعة الفتح';

  @override
  String get closeHour => 'ساعة القفل';

  @override
  String get selectCloseHour => 'اختار ساعة القفل';

  @override
  String get revenues => 'الايرادات';
}
