import 'dart:convert';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginService {
  LoginService._();

  Future<dynamic> login(String username, String password) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.LOGIN_API,
            body: json.encode({"usern": username, "passwd": password}),
            headers: {"Content-Type": "application/json"})
        .catchError((error) {
          throw new Exception("Please connect to the internet");
        })
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          final dynamic body = json.decode(response.body);
          if (response.statusCode != 200) {
            throw new Exception(body["msg"]);
          }
          return body;
        });
  }

  Future<dynamic> createAccount(String username, String password) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.REGISTER_API,
            body: json.encode({"usern": username, "passwd": password}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response resp) {
          if (resp.statusCode == 226) {
            throw new Exception("Username already exists!");
          }
          return json.decode(resp.body);
        });
  }

  factory LoginService() {
    return _instance;
  }

  static LoginService _instance = new LoginService._();
}
