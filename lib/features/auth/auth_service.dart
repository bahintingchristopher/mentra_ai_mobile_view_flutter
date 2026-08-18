import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/features/auth/user_model.dart';
import '../../learner/shared/services/storage_service.dart';

class AuthService {
  final String _baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

  /// Logs in using username and password, stores tokens, and returns [UserModel]
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
            

      final Map<String, dynamic> body = jsonDecode(response.body);
      final Map<String, dynamic> responseData = body['data'] ?? body;

      // Extract tokens according to your Django/Gunicorn API response structure
      final Map<String, dynamic>? tokens = responseData['tokens'];
      final String accessToken = tokens?['access'] ??
          responseData['access'] ??
          responseData['token'] ??
          '';
      final String sessionKey = tokens?['session_key'] ??
          responseData['session_key'] ??
          '';

      final String refreshToken = tokens?['refresh'] ??
        responseData['refresh'] ??
        '';
        // print ('Refresh token received : ${refreshToken.isNotEmpty}');

      // Save credentials using the static StorageService
      if (accessToken.isNotEmpty) {
        await StorageService.saveAuthData(
          accessToken: accessToken,
          sessionKey: sessionKey,
          userJson: jsonEncode(responseData['user'] ?? responseData),
          refreshToken: refreshToken,
        );
      }

      return UserModel.fromJson(responseData);
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);

      final String errorMessage = errorData['detail'] ??
          errorData['message'] ??
          'Invalid credentials. Please try again.';

      throw Exception(errorMessage);
    }
  }

  /// Fetches available SSO providers (e.g., Microsoft, Google)
  Future<Map<String, dynamic>> getSSOProviders() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/sso/providers/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {
      // Fallback empty map on failure so login UI degrades gracefully
    }
    return {};
  }

  /// Initiates SSO redirect / oauth flow
  Future<void> initiateSSO(String provider) async {
    // Add logic here when setting up OAuth webviews / deep-linking
  }
}