import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

  static Future<List<dynamic>> fetchFeedPosts({
    required String accessToken,
    String? sessionKey,
    int page = 1,
    int pageSize = 5,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/learner/feed/users/?page=$page&page_size=$pageSize',
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (sessionKey != null && sessionKey.isNotEmpty) {
      headers['session-key'] = sessionKey; // Or 'Cookie': 'sessionid=$sessionKey' based on Request Headers
    }

    final response = await http.get(uri, headers: headers);

    print('Feed StatusCode: ${response.statusCode}');
    print('Feed Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Handle response structure (paginated vs array)
      if (data is Map<String, dynamic>) {
        if (data.containsKey('results')) return data['results'];
        if (data.containsKey('data')) return data['data'];
      } else if (data is List) {
        return data;
      }
      return [];
    } else {
      throw Exception('Failed to fetch feed: ${response.statusCode}');
    }
  }
}