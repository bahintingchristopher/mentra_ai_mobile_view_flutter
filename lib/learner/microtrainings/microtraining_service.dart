import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentra_mobile_view/utils/api_config.dart';

class MicrotrainingService {
   static const String _baseUrl = ApiConfig.apiBaseUrl;

  /// Fetches microtrainings for the authenticated learner.
  /// 
  /// Parameters:
  /// - [accessToken]: JWT Bearer token stored in storage.
  /// - [status]: Filter by training status ('pending' or 'completed').
  /// - [searchQuery]: Optional search string to filter microtrainings by title.
  static Future<List<dynamic>> getMicrotrainings({
    required String accessToken,
    String status = 'pending',
    String searchQuery = '',
  }) async {
    // Construct URI with query parameters
    final Uri uri = Uri.parse(
      '$_baseUrl/learner/microtrainings/',
    ).replace(queryParameters: {
      'status': status,
      if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle both standard list responses and paginated responses ({ "results": [...] })
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic>) {
          return data['results'] ?? data['data'] ?? [];
        }
        
        return [];
      } else {
        throw Exception(
          'Failed to load microtrainings. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Log or rethrow error to be caught by FutureBuilder/UI
      rethrow;
    }
  }

  /// Marks a microtraining as completed by the learner.
  ///
  /// TODO: Update the endpoint URL to match the actual backend API.
  static Future<bool> markAsCompleted({
    required String accessToken,
    required int microtrainingId,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/learner/microtrainings/$microtrainingId/mark-complete/',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
