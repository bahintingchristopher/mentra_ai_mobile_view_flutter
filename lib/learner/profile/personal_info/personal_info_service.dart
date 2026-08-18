import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';

import 'personal_info_model.dart';

class PersonalInfoService {
    static const String baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

  Future<String?> _getToken() async {
    return await StorageService.getAccessToken();
  }

  Future<PersonalInfoModel?> fetchPersonalInfo() async {
    final accessToken = await _getToken();
  
    if (accessToken == null) {
        return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData ['data'] ?? responseData;

        return PersonalInfoModel(
          firstName: data['first_name'] ?? '',
          lastName: data['last_name'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phone_number'] ?? '',
        );
      }

      return null;
    } catch (e) {
       return null;
    }
  }

  Future<bool> updatePersonalInfo(
    PersonalInfoModel model,
  ) async {
    final accessToken = await _getToken();

    if (accessToken == null) {
         return false;
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/auth/profile/update/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': model.firstName,
          'last_name': model.lastName,
          'email': model.email,
          'phone_number': model.phoneNumber,
        }),
      );
 
      return response.statusCode == 200;
    } catch (e) {
        return false;
    }
  }
}