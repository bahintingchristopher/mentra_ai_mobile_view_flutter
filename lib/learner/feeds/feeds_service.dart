import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/learner/feeds/feed_model.dart';
import 'package:mentra_mobile_view/utils/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.apiBaseUrl;

  static Future<List<FeedPost>> fetchFeedPosts({
    required String accessToken,
    String? sessionKey,
    int page = 1,
    int pageSize = 5,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/learner/feed/?page=$page&page_size=$pageSize',
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (sessionKey != null && sessionKey.isNotEmpty) {
      headers['session-key'] = sessionKey;
    }

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> rawList = [];

      if (data is Map<String, dynamic>) {
        if (data.containsKey('posts')) {
          rawList = data['posts'] ?? []; // Key match for /learner/feed/
        } else if (data.containsKey('results')) {
          rawList = data['results'] ?? [];
        } else if (data.containsKey('data')) {
          rawList = data['data'] ?? [];
        }
      } else if (data is List) {
        rawList = data;
      }

      return rawList
          .map((item) => FeedPost.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch feed: ${response.statusCode}');
    }
  }
}