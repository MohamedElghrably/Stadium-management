import 'package:booking_stadium/models/stadium.dart';
import 'package:booking_stadium/providers/user_provider.dart';
import 'package:booking_stadium/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../widgets/new_booking_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  TabController? _tabController;
  int _selectedStadiumIndex = 0;
  // Animation controllers for slot interactions
  late AnimationController _slotHoverController;
  late AnimationController _slotTapController;
  Map<int, AnimationController> _slotControllers = {};
  Map<int, bool> _slotHoverStates = {};

  @override
  void initState() {
    super.initState();
    _slotHoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _slotTapController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider = context.read<UserProvider>();
      if (userProvider.currentUser != null) {
        context.read<BookingProvider>().initialize(
          userProvider.currentUser!.id,
        );
      } else {
        print(" [debug] Error: currentUser is null");
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _slotHoverController.dispose();
    _slotTapController.dispose();
    _slotControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  String _timeOfDayToString(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  List<Map<String, dynamic>> _generateTimeSlots(
    String open,
    String close,
    List<Booking> existingBookings,
  ) {
    // open/close in HH:mm
    final openParts = open.split(':');
    final closeParts = close.split(':');
    int openHour = int.tryParse(openParts[0]) ?? 8;
    int closeHour = int.tryParse(closeParts[0]) ?? 23;
    print(
      " [debug] _generateTimeSlots openHour: $openHour, closeHour: $closeHour",
    );
    List<Map<String, dynamic>> slots = [];

    // Check if this is an overnight schedule (open hour > close hour)
    bool isOvernight = openHour > closeHour;

    // Generate all possible slots from open to close
    int slotHour = openHour;
    int slotMinute = 0;

    if (isOvernight) {
      // Handle overnight schedule (e.g., 20:00 to 06:00)
      while (slotHour < 24) {
        int endHour2 = slotHour + 2;
        int endHour1 = slotHour + 1;

        // Try 2-hour slot first
        if (endHour2 <= 24) {
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour2.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 2,
            'isBooked': false,
          });
          slotHour = endHour2;
        } else if (endHour1 <= 24) {
          // Try 1-hour slot if 2-hour doesn't fit
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour1.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 1,
            'isBooked': false,
          });
          slotHour = endHour1;
        } else {
          break;
        }
      }

      // Continue from 00:00 to close hour
      slotHour = 0;
      while (slotHour < closeHour) {
        int endHour2 = slotHour + 2;
        int endHour1 = slotHour + 1;

        // Try 2-hour slot first
        if (endHour2 <= closeHour) {
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour2.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 2,
            'isBooked': false,
          });
          slotHour = endHour2;
        } else if (endHour1 <= closeHour) {
          // Try 1-hour slot if 2-hour doesn't fit
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour1.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 1,
            'isBooked': false,
          });
          slotHour = endHour1;
        } else {
          break;
        }
      }
    } else {
      // Handle normal schedule (e.g., 08:00 to 22:00)
      while (slotHour < closeHour) {
        int endHour2 = slotHour + 2;
        int endHour1 = slotHour + 1;

        // Try 2-hour slot first
        if (endHour2 <= closeHour) {
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour2.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 2,
            'isBooked': false,
          });
          slotHour = endHour2;
        } else if (endHour1 <= closeHour) {
          // Try 1-hour slot if 2-hour doesn't fit
          slots.add({
            'start':
                '${slotHour.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'end':
                '${endHour1.toString().padLeft(2, '0')}:${slotMinute.toString().padLeft(2, '0')}',
            'duration': 1,
            'isBooked': false,
          });
          slotHour = endHour1;
        } else {
          break;
        }
      }
    }

    // Mark booked slots
    for (var booking in existingBookings) {
      for (var slot in slots) {
        if (slot['start'] == booking.startTime &&
            slot['end'] == booking.endTime) {
          slot['isBooked'] = true;
          slot['booking'] = booking;
        }
      }
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final openHour = bookingProvider.openHour;
    final closeHour = bookingProvider.closeHour;
    List<Stadium> stadiums;
    stadiums = bookingProvider.stadiums;
    print(" [debug] dashboard_screen stadiums : $stadiums");

    if (stadiums.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_soccer, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'لا يوجد ملاعب متاحة',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final currentStadium = stadiums?[_selectedStadiumIndex];
    final bookingsForDay =
        bookingProvider
            .getBookingsByDate(_selectedDay)
            .where((booking) => booking.stadiumId == currentStadium?.id)
            .toList();

    final slots = _generateTimeSlots(
      _timeOfDayToString(openHour),
      _timeOfDayToString(closeHour),
      bookingsForDay,
    );
    print(" [debug] slots : $slots");

    print(" [debug] slots length: ${slots.length}");
    print(" [debug] openHour : ${openHour.toString()}");
    print(" [debug] closeHour : ${closeHour.toString()}");
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            if (bookingProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (bookingProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      bookingProvider.error!,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => bookingProvider.initialize(
                            userProvider.currentUser!.id,
                          ),
                      child: const Text('حاول تاني'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Enhanced header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.teal[400]!, Colors.teal[600]!],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'لوحة التحكم',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Stadium selection with enhanced design
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اختر الملعب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(stadiums.length, (i) {
                                    final s = stadiums[i];
                                    final isSelected =
                                        i == _selectedStadiumIndex;
                                    return Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedStadiumIndex = i;
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Colors.black
                                                      : Colors.white
                                                          .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border:
                                                  isSelected
                                                      ? Border.all(
                                                        color: Colors.white,
                                                        width: 2,
                                                      )
                                                      : null,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.sports_soccer,
                                                  color:
                                                      isSelected
                                                          ? Colors.teal[200]
                                                          : Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  s.name.isNotEmpty
                                                      ? s.name
                                                      : 'ملعب ${i + 1}',
                                                  style: TextStyle(
                                                    color:
                                                        isSelected
                                                            ? Colors.teal[200]
                                                            : Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Calendar section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.teal[600],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'التقويم',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        EasyDateTimeLine(
                          activeColor: Colors.teal,
                          initialDate: DateTime.now(),
                          locale: Localizations.localeOf(context).languageCode,

                          dayProps: EasyDayProps(
                            dayStructure: DayStructure.dayStrDayNum,
                            borderColor: Colors.black,

                            activeDayStyle: DayStyle(
                              dayNumStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              monthStrStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              dayStrStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          onDateChange: (selectedDate) {
                            setState(() {
                              _selectedDay = selectedDate;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Time slots section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.teal[600],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'مواعيد اليوم',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  currentStadium!.name.isNotEmpty
                                      ? currentStadium.name
                                      : 'ملعب ${_selectedStadiumIndex + 1}',
                                  style: TextStyle(
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.3,
                                ),
                            itemCount: slots.length,
                            itemBuilder: (context, idx) {
                              final slot = slots[idx];
                              final isBooked = slot['isBooked'] ?? false;
                              final booking = slot['booking'];

                              // Initialize animation controller for this slot if not exists
                              if (!_slotControllers.containsKey(idx)) {
                                _slotControllers[idx] = AnimationController(
                                  duration: Duration(milliseconds: 200),
                                  vsync: this,
                                );
                                _slotHoverStates[idx] = false;
                              }

                              final hoverAnimation = Tween<double>(
                                begin: 1.0,
                                end: 1.05,
                              ).animate(
                                CurvedAnimation(
                                  parent: _slotControllers[idx]!,
                                  curve: Curves.easeInOut,
                                ),
                              );

                              final colorAnimation = ColorTween(
                                begin:
                                    isBooked
                                        ? Color(0xFF9E9E9E)
                                        : Color(0xFF00897B),
                                end:
                                    isBooked
                                        ? Color(0xFF757575)
                                        : Color(0xFF004D40),
                              ).animate(
                                CurvedAnimation(
                                  parent: _slotControllers[idx]!,
                                  curve: Curves.easeInOut,
                                ),
                              );

                              return isBooked
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[600],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        '${slot['start']} - ${slot['end']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'محجوز',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap:
                                        () => NewBookingSheet.show(
                                          context,
                                          _selectedDay,
                                          initialStart: slot['start'],
                                          initialEnd: slot['end'],
                                          selectedStadium: currentStadium,
                                        ),
                                    onTapDown: (details) {
                                      _slotControllers[idx]!.forward();
                                      _slotTapController.forward();
                                    },
                                    onTapUp: (details) {
                                      _slotControllers[idx]!.reverse();
                                      _slotTapController.reverse();
                                    },
                                    onTapCancel: () {
                                      _slotControllers[idx]!.reverse();
                                      _slotTapController.reverse();
                                    },
                                    child: AnimatedBuilder(
                                      animation: Listenable.merge([
                                        _slotControllers[idx]!,
                                        _slotTapController,
                                      ]),
                                      builder: (context, child) {
                                        final scale =
                                            hoverAnimation.value *
                                            (1.0 +
                                                (_slotTapController.value *
                                                    0.1));
                                        return Transform.scale(
                                          scale: scale,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green[700],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.teal.withOpacity(
                                                    0.3 *
                                                        _slotControllers[idx]!
                                                            .value,
                                                  ),
                                                  blurRadius:
                                                      8 *
                                                      _slotControllers[idx]!
                                                          .value,
                                                  spreadRadius:
                                                      2 *
                                                      _slotControllers[idx]!
                                                          .value,
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.timer,
                                                color: Colors.white,
                                              ),
                                              title: Text(
                                                '${slot['start']} - ${slot['end']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'فاضي',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
