import 'dart:convert';
import 'package:guud_app/models/body_parameter_model.dart';
import 'package:guud_app/models/get_access_token_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Api._();
  static final Api instance = Api._();

  static const HOST = 'api.yodatech.cn';
  static const PORT = null;
  static const START_PATH = '/aip';

  Future<http.Response> accessToken(GetAccessToken getAccessToken) async {
    Uri url = Uri(
      scheme: 'https',
      host: HOST,
      port: PORT,
      path: '$START_PATH/jwt/token',
    );
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: const JsonEncoder().convert(getAccessToken.toJson()),
    );
  }

  Future<http.Response> bodyParameter(
      BodyParameter bodyParameter, String accessToken) async {
    Uri url = Uri(
      scheme: 'https',
      host: HOST,
      port: PORT,
      path: '$START_PATH/user/got/body/parameters',
    );

    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Auth-Token': accessToken.toString(),
      },
      body: const JsonEncoder().convert(bodyParameter.toJson()),
    );
  }
}
