import 'dart:convert';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/learner/notifications/notification_model.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';
import 'package:mentra_mobile_view/utils/api_config.dart';

class NotificationService {
   static const String _baseUrl = '${ApiConfig.apiBaseUrl}/learner/notifications';

  static Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final token = await StorageService.getAccessToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/?page=1&page_size=20'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        List<dynamic> listData = [];
        if (decodedBody is Map) {
          listData = decodedBody['notifications'] ?? decodedBody['results'] ?? decodedBody['data'] ?? [];
        } else if (decodedBody is List) {
          listData = decodedBody;
        }

        return listData.map((jsonItem) {
          final Map<String, dynamic> itemMap =
              Map<String, dynamic>.from(jsonItem as Map);
          return NotificationModel.fromJson(itemMap);
        }).toList();
      } else {
        return [];
      }
   } catch (e) {
         
      return [];
    }
  }

  static Future<bool> markAllAsRead() async {
    try {
      final token = await StorageService.getAccessToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/mark-all-read/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
     return false;
    }
  }
}