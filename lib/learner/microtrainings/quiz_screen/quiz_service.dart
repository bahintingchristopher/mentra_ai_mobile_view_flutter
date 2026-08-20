import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/utils/api_config.dart';
import 'quiz_model.dart';

class QuizService {
  static const String _baseUrl = ApiConfig.apiBaseUrl;

  static Future<QuizFreezeStatus> checkFreezeStatus({
    required String accessToken,
    required int microtrainingId,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/learner/microtrainings/$microtrainingId/quiz/freeze-status/',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return QuizFreezeStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check freeze status. Code: ${response.statusCode}');
    }
  }

  static Future<QuizSubmitResponse> submitQuiz({
    required String accessToken,
    required int microtrainingId,
    required List<QuizAnswerItem> answers,
  }) async {
    final uri = Uri.parse('$_baseUrl/learner/quiz/submit/');

    final body = json.encode({
      'microtraining_id': microtrainingId,
      'answers': answers.map((a) => a.toJson()).toList(),
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return QuizSubmitResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit quiz. Code: ${response.statusCode}');
    }
  }
}
