import 'dart:convert';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProfileService {
  ProfileService._();

  factory ProfileService() {
    return _instance;
  }

  Future<dynamic> getProfile(final String username) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.GET_PROFILE_API,
            body: json.encode({"usern": username}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response resp) {
          dynamic result = json.decode(resp.body);

          if (resp.statusCode == 404) {
            throw new Exception(result['msg']);
          }

          return result;
        });
  }

  Future<dynamic> createUpdateProfile(final String username, final String email,
      final String firstName, final String lastName, final String phone) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.CREATE_UPDATE_PROFILE,
            body: json.encode({
              "usern": username,
              "last": lastName,
              "first": firstName,
              "phone": phone,
              "email": email
            }),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response resp) {
          if (resp.statusCode != 200) {
            throw new Exception(
                json.decode(resp.body)['msg']);
          }
        });
  }

  Future<dynamic> changePassword(final String username, final String password,
      final String newPassword) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.CHANGE_PASSWORD,
            body: json.encode(
                {"usern": username, "passwd": password, "new": newPassword}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response resp) {
          if (resp.statusCode == 404) {
            throw new Exception(json.decode(resp.body)['msg']);
          }
        });
  }

  static final ProfileService _instance = new ProfileService._();
}
