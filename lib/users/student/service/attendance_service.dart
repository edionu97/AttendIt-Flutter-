import 'dart:convert';
import 'dart:io';

import 'package:attend_it/users/common/models/attendance.dart';
import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:dio/dio.dart';
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
        .then((http.Response resp) {
          if (resp.statusCode == 404) {
            throw new Exception("You must upload your face");
          }
        });
  }

  Future<List<Course>> getAllAvailableCourses() async {
    final http.Response response = await http.get(
        Constants.SERVER_ADDRESS + Constants.GET_ALL_AVAILABLE_COURSES,
        headers: {"Content-Type": "application/json"});

    final dynamic result = json.decode(response.body);

    final List<Course> courses = [];
    for (var element in result["courses"]) {
      courses.add(Course.fromJson(element));
    }

    return courses;
  }

  Future<List<Attendance>> getAttendancesForAt(
      final String username,
      final String teacherName,
      final String courseName,
      final String courseType) async {
    final http.Response response = await http.post(
        Constants.SERVER_ADDRESS + Constants.GET_ATTENDANCES_FOR_AT,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "student": username,
          "teacher": teacherName,
          "courseName": courseName,
          "courseType": courseType
        }));

    final dynamic result = json.decode(response.body);

    final List<Attendance> attendances = [];
    for (var element in result["attendances"]) {
      attendances.add(Attendance.fromJson(element));
    }

    return attendances;
  }

  Future<void> uploadAttendanceVideo(
      {final File file, final String teacher, final String cls}) async {
    return Dio()
        .post(Constants.SERVER_ADDRESS + Constants.UPLOAD_ATTENDANCE_VIDEO,
            data: FormData.from({
              "video":
                  UploadFileInfo(file, Constants.TMP_ATTENDANCE.substring(1)),
              "teacher": teacher,
              "cls": cls
            }))
        .timeout(const Duration(minutes: 5))
        .then((onValue) {
      if (onValue.statusCode != 200) {
        throw new Exception(onValue.statusCode);
      }
    });
  }

  factory AttendanceService() {
    return AttendanceService._instance;
  }

  static final AttendanceService _instance = new AttendanceService._();
}
