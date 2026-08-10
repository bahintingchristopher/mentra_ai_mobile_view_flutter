import 'dart:convert';
import 'package:http/http.dart' as http;


class MicrotrainingService {
  // Base URL matching your staging server
  static const String _baseUrl =
      'https://mentra-training-portal-be-staging.azurewebsites.net/api/v1';

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
}