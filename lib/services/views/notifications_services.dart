import 'package:flutter/material.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/repository/notifications_repo.dart';

class NotificationsServices {
  final _notificationsRepository = NotificationsRepository();
  //Calculate the time difference from now to the Notification's creation time
  static String getTimeAgo(String isoDateString) {
    final DateTime past = DateTime.parse(isoDateString).toLocal();
    final Duration diff = DateTime.now().difference(past);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  //Get Notifications
  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await _notificationsRepository.getNotifications();
      debugPrint('✅ NOTIFICATIONS  FETCHED: $response');
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[NotificationsService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[NotificationsService] ❌ Unexpected: $e');
      }
    }
    return {};
  }

  //Mark all Notifications as Read
  Future<Map<String, dynamic>> markNotificationsRead() async {
    try {
      final response =
          await _notificationsRepository.markAllNotificationsRead();
      debugPrint('✅ NOTIFICATIONS  MARK AS READ: $response');
      return response;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[NotificationsService] ❌ ${e.debugMessage}');
      } else {
        debugPrint('[NotificationsService] ❌ Unexpected: $e');
      }
    }
    return {};
  }
}
