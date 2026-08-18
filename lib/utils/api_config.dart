class ApiConfig {
  ApiConfig._();

  static const String _stagingHost =
      'https://mentra-training-portal-be-staging.azurewebsites.net';

  static const String host = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _stagingHost,
  );

  static const String apiBaseUrl = '$host/api/v1';
}