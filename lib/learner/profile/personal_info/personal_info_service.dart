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
      // print('No access token found.');
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

      // print('Fetch profile status: ${response.statusCode}');
      // print('Fetch profile response: ${response.body}');

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
      // print('Error fetching profile: $e');
      return null;
    }
  }

  Future<bool> updatePersonalInfo(
    PersonalInfoModel model,
  ) async {
    final accessToken = await _getToken();

    if (accessToken == null) {
      // print('No access token found.');
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

      // print('Update profile status: ${response.statusCode}');
      // print('Update profile response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      // print('Error updating profile: $e');
      return false;
    }
  }
}