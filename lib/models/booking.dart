import 'package:intl/intl.dart';

enum BookingStatus { pending, confirmed, completed, cancelled, noShow }

class Booking {
  String id;
  final String stadiumId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration; // in hours
  final double totalPrice;
  final int deposit;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? paymentMethod;
  final bool isPaid;
  final bool isFixed;

  Booking({
    required this.id,
    required this.stadiumId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    required this.deposit,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.paymentMethod,
    this.isPaid = false,
    this.isFixed = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      stadiumId: json['stadiumId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      deposit: json['deposit'] ?? 0,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'] ?? false,
      isFixed: json['isFixed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stadiumId': stadiumId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'totalPrice': totalPrice,
      'deposit': deposit,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'isFixed': isFixed,
    };
  }

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);
  String get formattedTime => '$startTime - $endTime';
  String get formattedPrice => '\$${totalPrice.toStringAsFixed(2)}';
  String get statusText => status.toString().split('.').last.toUpperCase();

  Booking copyWith({
    String? id,
    String? stadiumId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? duration,
    double? totalPrice,
    int? deposit,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentMethod,
    bool? isPaid,
    bool? isFixed,
  }) {
    return Booking(
      id: id ?? this.id,
      stadiumId: stadiumId ?? this.stadiumId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      totalPrice: totalPrice ?? this.totalPrice,
      deposit: deposit ?? this.deposit,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      isFixed: isFixed ?? this.isFixed,
    );
  }
}
