import 'package:booking_stadium/providers/user_provider.dart';
import 'package:booking_stadium/screens/profile_screen.dart';
import 'package:booking_stadium/screens/splash_screen.dart';
import 'package:booking_stadium/widgets/new_booking_sheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'screens/dashboard_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/bookings_screen.dart';
import 'models/stadium.dart';
import 'screens/revenues_screen.dart';
import 'services/notification_helper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/auth_screen.dart';

TextDirection getRtlTextDirection() {
  return TextDirection.values.length > 1
      ? TextDirection.values[1]
      : TextDirection.ltr;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  await initializeDateFormatting('ar', null);
  await NotificationHelper.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Export MyAppState for use in other files
class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stadium Booking Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => OnboardingScreen(setLocale: setLocale),
        '/auth': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class OnboardingScreen extends StatefulWidget {
  final void Function(Locale)? setLocale;
  const OnboardingScreen({super.key, this.setLocale});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _stadiumCount;
  TimeOfDay? _openHour;
  TimeOfDay? _closeHour;
  int? _hourlyPrice;

  String? _validateTime(TimeOfDay? time) {
    if (time == null) {
      return 'من فضلك اختار الوقت';
    }
    return null;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime({required bool isOpen}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          isOpen
              ? (_openHour ?? TimeOfDay(hour: 8, minute: 0))
              : (_closeHour ?? TimeOfDay(hour: 23, minute: 0)),
      builder: (context, child) {
        return Directionality(
          textDirection: getRtlTextDirection(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isOpen) {
          _openHour = TimeOfDay(hour: picked.hour, minute: picked.minute);
        } else {
          _closeHour = TimeOfDay(hour: picked.hour, minute: picked.minute);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[400]!, Colors.teal[700]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header section with icon and title
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'يلا بينا نبدأ!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'إعدادات الملاعب الأساسية',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Stadium count field
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'عدد الملاعب',
                            hintText: 'مثال: 3',
                            prefixIcon: const Icon(Icons.sports_soccer),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك ادخل عدد الملاعب';
                            }
                            if (int.tryParse(value) == null) {
                              return 'اكتب رقم صحيح';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _stadiumCount = int.tryParse(value ?? '');
                          },
                        ),
                        const SizedBox(height: 20),

                        // Hourly price field
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'سعر الساعة (بالجنيه)',
                            hintText: 'مثال: 100',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك ادخل سعر الساعة';
                            }
                            if (int.tryParse(value) == null) {
                              return 'اكتب رقم صحيح';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _hourlyPrice = int.tryParse(value ?? '');
                          },
                        ),
                        const SizedBox(height: 20),

                        // Opening hours section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.teal[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ساعات العمل',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.teal[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Opening time
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(isOpen: true),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                _openHour != null
                                                    ? Colors.teal[300]!
                                                    : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ساعة الفتح',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _openHour == null
                                                        ? 'اختر الوقت'
                                                        : _formatTime(
                                                          _openHour,
                                                        ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.access_time,
                                              color:
                                                  _openHour != null
                                                      ? Colors.teal[600]
                                                      : Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(isOpen: false),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                _closeHour != null
                                                    ? Colors.teal[300]!
                                                    : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'ساعة القفل',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _closeHour == null
                                                        ? 'اختر الوقت'
                                                        : _formatTime(
                                                          _closeHour,
                                                        ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.access_time,
                                              color:
                                                  _closeHour != null
                                                      ? Colors.teal[600]
                                                      : Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Start button
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              final valid =
                                  _formKey.currentState!.validate() &&
                                  _openHour != null &&
                                  _closeHour != null;
                              setState(() {}); // To update errorText
                              if (valid) {
                                _formKey.currentState!.save();
                                if (_hourlyPrice != null &&
                                    _stadiumCount != null) {
                                  bookingProvider.setOpenHour(_openHour!);
                                  bookingProvider.setCloseHour(_closeHour!);
                                  bookingProvider.setHourlyPrice(_hourlyPrice!);
                                  print(
                                    " [debug] _stadiumCount: $_stadiumCount",
                                  );
                                  print(" [debug] _openHour: $_openHour");
                                  print(" [debug] _closeHour: $_closeHour");
                                  for (int i = 0; i < _stadiumCount!; i++) {
                                    bookingProvider.addStadium(
                                      Stadium(
                                        id:
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString() +
                                            i.toString(),
                                        name: 'ملعب ${i + 1}',
                                        location: '',
                                        description: '',
                                        pricePerHour: 0,
                                        amenities: [],
                                        images: [],
                                        isAvailable: true,
                                        capacity: 0,
                                        surfaceType: '',
                                        operatingHours: {},
                                        openHour: _openHour!,
                                        closeHour: _closeHour!,
                                      ),
                                      userProvider.currentUser!.id,
                                    );
                                  }
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushReplacement(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const MainNavShell(),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.rocket_launch),
                                const SizedBox(width: 8),
                                Text(
                                  'ابدأ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavShell extends StatefulWidget {
  const MainNavShell({Key? key}) : super(key: key);

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _selectedIndex = 0;
  DateTime _selectedDay = DateTime.now();

  final List<Widget> _screens = [
    DashboardScreen(),
    BookingsScreen(),
    RevenuesScreen(), // <-- new tab
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,

          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'المواعيد المتاحة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'الحجوزات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'الايرادات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الإعدادات',
            ),
          ],
          selectedItemColor: Colors.teal[300],
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black87,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NewBookingSheet.show(context, _selectedDay),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.teal[300],
        child: Icon(Icons.add, size: 32),
        shape: CircleBorder(side: BorderSide(width: 4, color: Colors.teal)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
