import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reaction_counter_model.dart';

class ReactionCounterService {
  final String baseUrl;

  // ReactionCounterService({this.baseUrl = 'https://staging.mentra-train.ai/api'});
   ReactionCounterService({this.baseUrl =  'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1'});

  Future<List<ReactionUserModel>> fetchPostReactions(int postId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/post-reactions/?post=$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => ReactionUserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post reactions (${response.statusCode})');
    }
  }
}