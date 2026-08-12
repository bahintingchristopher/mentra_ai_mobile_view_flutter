import 'dart:convert';
import 'package:http/http.dart' as http;

class LikeService {
  static const String baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

  static Future<void> sendReaction({
    required int postId,
    required String reaction,
    required String accessToken,
    String? sessionKey,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/learner/posts/$postId/react/',
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (sessionKey != null && sessionKey.isNotEmpty) {
      headers['session-key'] = sessionKey;
    }

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'reaction_type': reaction,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to send reaction: ${response.statusCode}',
      );
    }
  }
}