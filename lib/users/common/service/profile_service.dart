import 'dart:convert';
import 'dart:io';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

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
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((http.Response resp) {
          if (resp.body.isEmpty) {
            return json.decode("{}");
          }

          dynamic result = json.decode(resp.body);

          if (resp.statusCode == 404) {
            throw new Exception(result['msg']);
          }

          result["image"] = Image.memory(
              base64.decode(result["image"].toString().split(",")[1]));
          return result;
        });
  }

  Future<dynamic> createUpdateProfile(final String username, final String email,
      final String firstName, final String lastName, final String phone) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.CREATE_UPDATE_PROFILE_API,
            body: json.encode({
              "usern": username,
              "last": lastName,
              "first": firstName,
              "phone": phone,
              "email": email
            }),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((http.Response resp) {
          if (resp.statusCode != 200) {
            throw new Exception(json.decode(resp.body)['msg']);
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
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((http.Response resp) {
          if (resp.statusCode == 404) {
            throw new Exception(json.decode(resp.body)['msg']);
          }
        });
  }

  Future<dynamic> uploadImage(final String username, final File image) async {
    final String extension =
        new RegExp(r".*\.([a-z]+)$").firstMatch(image.path).group(1);

    // ignore: unnecessary_brace_in_string_interps
    final String encodedImage = "data:image/${extension};base64," +
        base64Encode(image.readAsBytesSync());

    return http
        .post(Constants.SERVER_ADDRESS + Constants.UPLOAD_PICTURE_API,
            body: json.encode({"usern": username, "image": encodedImage}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((http.Response resp) {
          if (resp.statusCode == 404) {
            throw new Exception(json.decode(resp.body)['msg']);
          }
        });
  }

  Future<dynamic> uploadVideoRecords(final String username) async {

    final Directory directory = await getTemporaryDirectory();
    final File fileTmpLeftRight = new File(directory.path + Constants.TMP_LEFT_RIGHT);
    final File fileTmpUpDown = new File(directory.path + Constants.TMP_UP_DOWN);

    if (!fileTmpLeftRight.existsSync()) {
      throw new Exception("Tmp file left-right not found!");
    }

    if(!fileTmpUpDown.existsSync()){
      throw new Exception("Tmp file up-down not found!");
    }

    return Dio()
        .post(Constants.SERVER_ADDRESS + Constants.UPLOAD_LEFT_RIGHT_API,
            data: FormData.from({
              "fileLeftRight":
                  UploadFileInfo(fileTmpLeftRight, Constants.TMP_LEFT_RIGHT.substring(1)),
              "fileUpDown": UploadFileInfo(fileTmpUpDown, Constants.TMP_UP_DOWN.substring(1)),
              "user": username
            }))
        .timeout(const Duration(minutes: 5))
        .catchError((err) => throw new Exception("Cannot send file to server"))
        .then((onValue) {
      if (onValue.statusCode != 200) {
        throw new Exception(onValue.statusCode);
      }
    });
  }

  static final ProfileService _instance = new ProfileService._();
}
