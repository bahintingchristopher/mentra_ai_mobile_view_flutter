import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comment_model.dart';

class CommentService {
  static const String baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

  // ============================================================
  // GET COMMENTS
  // ============================================================

  static Future<List<CommentModel>> getComments({
    required int postId,
    required String accessToken,
    String? sessionKey,
    int page = 1,
    int pageSize = 20,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/learner/posts/$postId/comments/?page=$page&page_size=$pageSize',
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (sessionKey != null && sessionKey.isNotEmpty) {
      headers['session-key'] = sessionKey;
    }

    print('GET COMMENTS URL: $uri');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Comment GET StatusCode: ${response.statusCode}');
    print('Comment GET Response: ${response.body}');

   if (response.statusCode == 200) {
  final data = jsonDecode(response.body);

  List<dynamic> rawComments = [];

  if (data is Map<String, dynamic>) {
    if (data['comments'] is List) {
      rawComments = data['comments'];
    } else if (data['results'] is List) {
      rawComments = data['results'];
    } else if (data['data'] is List) {
      rawComments = data['data'];
    }
  } else if (data is List) {
    rawComments = data;
  }

  return rawComments
      .map(
        (item) => CommentModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}

    throw Exception(
      'Failed to load comments: ${response.statusCode}',
    );
  }

  // ============================================================
  // CREATE COMMENT
  // ============================================================

  static Future<CommentModel> addComment({
    required int postId,
    required String content,
    required String accessToken,
    String? sessionKey,
    int? parentId,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/learner/posts/$postId/comments/create/',
    );

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    if (sessionKey != null && sessionKey.isNotEmpty) {
      headers['session-key'] = sessionKey;
    }

    final body = jsonEncode({
      'content': content,
      'parent_id': parentId,
    });

    print('CREATE COMMENT URL: $uri');
    print('CREATE COMMENT BODY: $body');

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    print('Comment POST StatusCode: ${response.statusCode}');
    print('Comment POST Response: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return CommentModel.fromJson(
        data as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to create comment: ${response.statusCode}',
    );
  }
}