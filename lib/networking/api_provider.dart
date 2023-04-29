import 'package:coverlo/networking/base_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiProvider extends BaseAPI {
  @override
  Future<dynamic> get(String url) async {
    http.Response response = await http.get(Uri.parse(baseUrl + url));
    return json.decode(response.body);
  }

  @override
  Future<dynamic> post(String url, Map body) async {
    http.Response response =
        await http.post(Uri.parse(baseUrl + url), body: body);
    return json.decode(response.body);
  }
}
