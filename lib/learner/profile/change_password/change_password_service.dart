import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/utils/api_config.dart';

import 'change_password_model.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';

class ChangePasswordService {
    static const String _url = '${ApiConfig.apiBaseUrl}/auth/change-password/';

  Future<bool> changePassword(ChangePasswordModel model) async {
    try {
      final accessToken = await StorageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
            return false;
      }

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(model.toJson()),
      );

          if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return true;
      }

      return false;
    } catch (e) {
      // 
      return false;
    }
  }
}