import 'package:coverlo/env/env.dart';

abstract class BaseAPI {
  final String baseUrl = Env.appUrl;
  Future<dynamic> post(String url, Map body);
  Future<dynamic> get(String url);
}
