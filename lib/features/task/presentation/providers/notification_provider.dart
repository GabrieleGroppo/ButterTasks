import 'package:flutter/material.dart';

import '../../domain/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationProvider({required this.repository});

  Future<void> scheduleNotification(Notification notification) async {
    await repository.scheduleNotification(notification);
  }

  Future<void> cancelNotification(int id) async {
    await repository.cancelNotification(id);
  }

  Future<void> cancelAllNotifications() async {
    await repository.cancelAllNotifications();
  }
}
