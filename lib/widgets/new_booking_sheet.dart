import 'package:booking_stadium/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stadium.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';

class NewBookingSheet extends StatefulWidget {
  final DateTime selectedDay;
  final String? initialStart;
  final String? initialEnd;

  const NewBookingSheet({
    required this.selectedDay,
    this.initialStart,
    this.initialEnd,
    Key? key,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context,
    DateTime selectedDay, {
    String? initialStart,
    String? initialEnd,
    Stadium? selectedStadium,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => NewBookingSheet(
            selectedDay: selectedDay,
            initialStart: initialStart,
            initialEnd: initialEnd,
          ),
    );
  }

  @override
  State<NewBookingSheet> createState() => _NewBookingSheetState();
}

class _NewBookingSheetState extends State<NewBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _deposit;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Stadium? _selectedStadium;
  String selectedStadiumName = "ffff";
  bool _repeatWeekly = false;
  int _repeatCount = 8;

  @override
  void initState() {
    super.initState();
    if (widget.initialStart != null) {
      final parts = widget.initialStart!.split(':');
      if (parts.length == 2) {
        _startTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    if (widget.initialEnd != null) {
      final parts = widget.initialEnd!.split(':');
      if (parts.length == 2) {
        _endTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حجز جديد',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'إضافة حجز جديد للملعب',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stadium Selection
                        _buildSectionTitle('اختر الملعب', Icons.sports_soccer),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<Stadium>(
                            value: _selectedStadium,
                            items:
                                bookingProvider.stadiums
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.sports_soccer,
                                              size: 20,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(s.name),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (s) => setState(() => _selectedStadium = s),
                            decoration: const InputDecoration(
                              labelText: 'اختر الملعب',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (v) => v == null ? 'اختر الملعب' : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Customer Information
                        _buildSectionTitle('معلومات العميل', Icons.person),
                        const SizedBox(height: 8),
                        _buildTextField(
                          label: 'اسم العميل',
                          icon: Icons.person_outline,
                          onSaved: (v) => _name = v,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty ? 'ادخل الاسم' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'رقم التليفون',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          onSaved: (v) => _phone = v,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'ادخل رقم التليفون'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'العربون',
                          icon: Icons.attach_money_outlined,
                          keyboardType: TextInputType.number,
                          onSaved: (v) => _deposit = v,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'ادخل العربون'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        // Time Selection
                        _buildSectionTitle('وقت الحجز', Icons.access_time),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimeField(
                                label: 'بداية الوقت',
                                icon: Icons.play_arrow,
                                time: _startTime,
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 8, minute: 0),
                                  );
                                  if (picked != null)
                                    setState(() => _startTime = picked);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTimeField(
                                label: 'نهاية الوقت',
                                icon: Icons.stop,
                                time: _endTime,
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _startTime ??
                                        TimeOfDay(hour: 9, minute: 30),
                                  );
                                  if (picked != null)
                                    setState(() => _endTime = picked);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Repeat Booking
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: _repeatWeekly,
                            onChanged:
                                (v) =>
                                    setState(() => _repeatWeekly = v ?? false),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text('حجز مثبت (تكرار الحجز كل أسبوع)'),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                        if (_repeatWeekly) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(
                                0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text('عدد الأسابيع:'),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<int>(
                                    value: _repeatCount,
                                    items:
                                        List.generate(12, (i) => i + 1)
                                            .map(
                                              (n) => DropdownMenuItem(
                                                value: n,
                                                child: Text(
                                                  '$n',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        (v) => setState(
                                          () => _repeatCount = v ?? 8,
                                        ),
                                    dropdownColor: theme.colorScheme.primary,
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('إلغاء'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_selectedStadium == null ||
                                        _startTime == null ||
                                        _endTime == null)
                                      return;
                                    final provider =
                                        Provider.of<BookingProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final now = DateTime.now();
                                    final List<DateTime> dates =
                                        _repeatWeekly
                                            ? List.generate(
                                              _repeatCount,
                                              (i) => widget.selectedDay.add(
                                                Duration(days: 7 * i),
                                              ),
                                            )
                                            : [widget.selectedDay];
                                    bool allSuccess = true;
                                    for (final date in dates) {
                                      final booking = Booking(
                                        id: '',
                                        stadiumId: _selectedStadium!.id,
                                        customerName: _name ?? '',
                                        customerPhone: _phone ?? '',
                                        customerEmail: '',
                                        date: DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                        ),
                                        startTime: _formatTime(_startTime),
                                        endTime: _formatTime(_endTime),
                                        duration: _calcDuration(
                                          _startTime!,
                                          _endTime!,
                                        ),
                                        totalPrice:
                                            (provider.hourlyPrice *
                                                    _calcDuration(
                                                      _startTime!,
                                                      _endTime!,
                                                    ))
                                                .toDouble(),
                                        deposit:
                                            int.tryParse(_deposit ?? '0') ?? 0,
                                        status: BookingStatus.confirmed,
                                        notes: null,
                                        createdAt: now,
                                        updatedAt: null,
                                        paymentMethod: null,
                                        isPaid: false,
                                        isFixed: _repeatWeekly,
                                      );
                                      final success = await provider
                                          .createBooking(
                                            booking,
                                            userProvider.currentUser!.id,
                                          );
                                      if (!success) {
                                        allSuccess = false;
                                        await showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('خطأ'),
                                                content: Text(
                                                  provider.error ??
                                                      'حدث خطأ أثناء الحجز',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: const Text('حسناً'),
                                                  ),
                                                ],
                                              ),
                                        );
                                        break;
                                      }
                                    }
                                    if (allSuccess) {
                                      bookingProvider.clearError();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            _repeatWeekly
                                                ? 'تم إضافة الحجوزات المتكررة'
                                                : 'تم إضافة الحجز',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('احجز'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required IconData icon,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    time == null ? 'اختر' : time.format(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _calcDuration(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return ((endMinutes - startMinutes) / 60).round();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
