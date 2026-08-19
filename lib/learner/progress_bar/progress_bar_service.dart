import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/utils/api_config.dart';

import 'progress_bar_model.dart';

class ProgressBarService {
  static const String baseUrl = ApiConfig.apiBaseUrl;

  Future<ProgressBarModel> fetchProgress({
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/learner/progress/'
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return ProgressBarModel.fromJson(jsonData);
    }

    throw Exception(
      'Failed to load progress: ${response.statusCode}',
    );
  }
}