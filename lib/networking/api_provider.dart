// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/networking/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:xml/xml.dart';

class ApiProvider extends BaseAPI {
  @override
  Future<dynamic> post(String url, String body) async {
    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(baseUrl + url),
              headers: {
                'Content-Type': 'text/xml',
              },
              body: body)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'Connection timed out. Slow internet connection.');
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
          'Connection timed out. Slow internet connection');
    } on Error {
      throw FetchDataException('Something went wrong');
    }

    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final document = XmlDocument.parse(response.body);

        var responseJson = json.decode(document
            .getElement('soap:Envelope')
            ?.firstElementChild
            ?.firstElementChild
            ?.firstElementChild
            ?.firstChild
            ?.text as String);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 402:
        throw NotFoundException(response.body.toString());
      case 404:
        throw NotFoundException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        final document = XmlDocument.parse(response.body);
        return document.toString();
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
