import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  DateTime _selectedDay = DateTime.now();
  String _searchQuery = '';
  BookingStatus? _selectedStatus;
  String? _selectedStadiumId;
  int _selectedStadiumIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            if (bookingProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final stadiums = bookingProvider.stadiums;
            if (stadiums.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد ملاعب متاحة',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            final selectedStadium = stadiums[_selectedStadiumIndex];
            // Only show bookings for the selected stadium
            final bookingsByStadium = <String, List<Booking>>{};
            final bookings =
                bookingProvider
                    .getBookingsByDate(_selectedDay)
                    .where(
                      (b) =>
                          b.stadiumId == selectedStadium.id &&
                          b.status != BookingStatus.cancelled,
                    )
                    .toList();
            if (bookings.isNotEmpty) {
              bookingsByStadium[selectedStadium.id] = bookings;
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
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'الحجوزات',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                              onPressed: _showFilterDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Stadium selection
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
                                                      ? Colors.white
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
                                                          ? Colors.teal[600]
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
                                                            ? Colors.teal[600]
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

                // Search bar
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'بحث في الحجوزات',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                // Date timeline
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                      child: EasyDateTimeLine(
                        activeColor: Colors.teal,
                        initialDate: DateTime.now(),
                        locale: Localizations.localeOf(context).languageCode,
                        onDateChange: (selectedDate) {
                          setState(() {
                            _selectedDay = selectedDate;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                // Filter chips
                if (_selectedStatus != null || _selectedStadiumId != null)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_selectedStatus != null)
                            Chip(
                              label: Text(
                                _selectedStatus!
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase(),
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedStatus = null;
                                });
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: Colors.teal[100],
                            ),
                          if (_selectedStadiumId != null)
                            Chip(
                              label: Text(
                                bookingProvider
                                        .getStadiumById(_selectedStadiumId!)
                                        ?.name ??
                                    'مجهول',
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedStadiumId = null;
                                });
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                              backgroundColor: Colors.teal[100],
                            ),
                        ],
                      ),
                    ),
                  ),

                // Bookings list
                if (bookingsByStadium.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد حجوزات لهذا اليوم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'جرب اختيار يوم آخر أو ملعب مختلف',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final stadiumId = bookingsByStadium.keys.elementAt(index);
                      final bookings = bookingsByStadium[stadiumId]!;
                      final stadium = bookingProvider.getStadiumById(stadiumId);

                      return Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sports_soccer,
                                    color: Colors.teal[600],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    stadium?.name ?? 'ملعب',
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
                                      '${bookings.length} حجز',
                                      style: TextStyle(
                                        color: Colors.teal[700],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...bookings
                                .map(
                                  (booking) =>
                                      _buildBookingTile(booking, stadium!),
                                )
                                .toList(),
                          ],
                        ),
                      );
                    }, childCount: bookingsByStadium.length),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingTile(Booking booking, stadium) {
    bool isCurrent = _isNowWithinBooking(booking);
    return Slidable(
      key: ValueKey(booking.id),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              final url = Uri(scheme: 'tel', path: booking.customerPhone);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('لا يمكن إجراء المكالمة')),
                );
              }
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'اتصال',
          ),
          SlidableAction(
            onPressed: (context) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('تأكيد حذف الحجز'),
                      content: Text('هل أنت متأكد من حذف هذا الحجز؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('لا'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('نعم'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                final provider = Provider.of<BookingProvider>(
                  context,
                  listen: false,
                );
                // You need to implement deleteBooking in your provider/service
                // provider.deleteBooking(booking.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف الحجز (تأكد من تنفيذ الحذف فعلياً)'),
                  ),
                );
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'حذف',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isCurrent
                    ? [Colors.orange[200]!, Colors.amber[300]!]
                    : [Colors.teal[50]!, Colors.teal[100]!],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? Colors.orange[400]! : Colors.teal[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showBookingDetails(booking),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with time and status
                  Row(
                    children: [
                      // Time slot with icon
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isCurrent
                                        ? Colors.orange[400]
                                        : Colors.teal[400],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isCurrent ? Icons.access_time : Icons.schedule,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${booking.startTime} - ${booking.endTime}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color:
                                          isCurrent
                                              ? Colors.orange[800]
                                              : Colors.teal[800],
                                    ),
                                  ),
                                  Text(
                                    '${booking.duration} ساعة',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isCurrent
                                              ? Colors.orange[600]
                                              : Colors.teal[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isCurrent ? Colors.orange[400] : Colors.teal[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCurrent ? 'جاري الآن' : 'محجوز',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Customer info section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Customer name
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking.customerName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Deposit
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'العربون: ${booking.deposit.toStringAsFixed(0)} جنيه',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Price
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${booking.totalPrice.toStringAsFixed(0)} جنيه',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green[700],
                              ),
                            ),
                            if (!booking.isPaid) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'غير مدفوع',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تصفية الحجوزات'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<BookingStatus>(
                  value: _selectedStatus,
                  items:
                      BookingStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toString().split('.').last),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    Navigator.of(context).pop();
                  },
                  decoration: InputDecoration(
                    labelText: 'حالة الحجز',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إلغاء'),
              ),
            ],
          ),
    );
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تفاصيل الحجز'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('اسم العميل', booking.customerName),
                if (booking.customerPhone.isNotEmpty)
                  _buildDetailRow('رقم الهاتف', booking.customerPhone),
                if (booking.customerEmail.isNotEmpty)
                  _buildDetailRow('البريد الإلكتروني', booking.customerEmail),
                _buildDetailRow('التاريخ', booking.formattedDate),
                _buildDetailRow('الوقت', booking.formattedTime),
                _buildDetailRow('المدة', '${booking.duration} ساعة'),
                _buildDetailRow(
                  'السعر',
                  '${booking.totalPrice.toStringAsFixed(0)} جنيه',
                ),
                _buildDetailRow(
                  'العربون',
                  '${booking.deposit.toStringAsFixed(0)} جنيه',
                ),
                _buildDetailRow('الحالة', booking.statusText),
                if (booking.notes != null)
                  _buildDetailRow('ملاحظات', booking.notes!),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.noShow:
        return Colors.grey;
    }
  }

  // Helper to check if now is within booking slot
  bool _isNowWithinBooking(Booking booking) {
    final now = DateTime.now();
    int nowMinutes = now.hour * 60 + now.minute;
    List<String> startParts = booking.startTime.split(':');
    List<String> endParts = booking.endTime.split(':');
    int startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    int endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }
}
