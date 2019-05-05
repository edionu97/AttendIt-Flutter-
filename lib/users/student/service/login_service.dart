import 'dart:convert';

import 'package:attend_it/users/student/service/models/user.dart';
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

  Future<dynamic> getUserDetails(final String username) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.GET_USER_INFO,
            body: json.encode({"usern": username}),
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

  Future<List<User>> getUsers() async {
    return http
        .get(Constants.SERVER_ADDRESS + Constants.GET_ALL_USERS,
            headers: {"Content-Type": "application/json"})
        .catchError((error) {
          throw new Exception("Please connect to the internet");
        })
        .timeout(const Duration(seconds: 60))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          final dynamic body = json.decode(response.body);
          if (response.statusCode != 200) {
            throw new Exception(body["msg"]);
          }
          final List<User> users = [];
          for (var element in body["users"]) {
            users.add(User.fromJson(element));
          }
          return users;
        });
  }

  Future<dynamic> setRole(String username, String role) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.SET_ROLE,
            body: json.encode({"username": username, "role": role}),
            headers: {"Content-Type": "application/json"})
        .catchError((error) {
          throw new Exception("Please connect to the internet");
        })
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            final dynamic body = json.decode(response.body);
            throw new Exception(body["msg"]);
          }
        });
  }

  factory LoginService() {
    return _instance;
  }

  static LoginService _instance = new LoginService._();
}
