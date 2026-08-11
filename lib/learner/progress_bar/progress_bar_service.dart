import 'dart:convert';
import 'package:http/http.dart' as http;

import 'progress_bar_model.dart';

class ProgressBarService {
  static const String baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net';

  Future<ProgressBarModel> fetchProgress({
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/v1/learner/progress/',
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