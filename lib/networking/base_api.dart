import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class BaseAPI {
  final String baseUrl = dotenv.env['API_URL1'] ?? '';

  Future<dynamic> post(String url, String body);
}
