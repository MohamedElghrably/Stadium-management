import 'package:booking_stadium/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationsScreen({Key? key, required this.notifications})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        backgroundColor: Colors.teal,
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  "لا توجد إشعارات",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.teal,
                    ),
                    title: Text(
                      n.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(n.body),
                    trailing: Text(
                      "${n.timestamp.hour}:${n.timestamp.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
    );
  }
}

// Example usage
// class TestScreen extends StatelessWidget {
//   const TestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sampleNotifications = [
//       NotificationModel(
//         title: "طلب إشراف",
//         body: "أحمد يريد الإنضمام إلى ملعب الأهلي",
//         timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
//       ),
//       NotificationModel(
//         title: "قبول",
//         body: "تمت الموافقة على طلبك",
//         timestamp: DateTime.now().subtract(const Duration(hours: 1)),
//       ),
//     ];

//     return NotificationsScreen(notifications: sampleNotifications);
//   }
// }
