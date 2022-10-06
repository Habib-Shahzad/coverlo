

import 'package:coverlo/env/env.dart';

abstract class BaseAPI {
  final String baseUrl = Env.appUrl1;

  Future<dynamic> post(String url, String body);
}
