import 'dart:convert';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AttendanceService {
  AttendanceService._();

  /*
   *  Check if the user has face registered
   *  @param username: user's username
   *  throws error if the face is not found else does nothing
   */
  Future<void> checkFaceRegistration(final String username) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.CHECK_FACE,
            body: json.encode({"usern": username}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) {
          throw new Exception("Could not get any response from server");
        })
        .then((Response resp) {
          if (resp.statusCode == 404) {
            throw new Exception("You must upload your face");
          }
        });
  }

  factory AttendanceService() {
    return AttendanceService._instance;
  }

  static final AttendanceService _instance = new AttendanceService._();
}
