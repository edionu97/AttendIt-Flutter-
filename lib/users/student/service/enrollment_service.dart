import 'dart:convert';

import 'package:attend_it/users/student/service/models/course.dart';
import 'package:attend_it/users/student/service/models/enrollment.dart';
import 'package:attend_it/utils/constants/constants.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EnrollmentService {
  EnrollmentService._();

  Future<bool> isEnrolled(final Course course, final String username) async {
    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.CHECK_STUDENT_ENROLLMENT,
            body: json.encode({
              "student": username,
              "teacher": course.user.username,
              "courseName": course.name,
              "courseType": course.type,
            }),
            headers: {"Content-Type": "application/json"})
        .catchError((error) {
          throw new Exception(error.toString());
        });

    return response.statusCode == 302;
  }

  Future<dynamic> cancelEnrollment(
      final String username, final Course course) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.REMOVE_STUDENT_ENROLLMENT,
            body: json.encode({
              "student": username,
              "teacher": course.user.username,
              "courseName": course.name,
              "courseType": course.type,
            }),
            headers: {"Content-Type": "application/json"})
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

  Future<dynamic> enroll(
      {final String username, final Course course, final String group}) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.ADD_STUDENT_ENROLLMENT,
            body: json.encode({
              "student": username,
              "teacher": course.user.username,
              "courseName": course.name,
              "courseType": course.type,
              "group": group
            }),
            headers: {"Content-Type": "application/json"})
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

  Future<List<Enrollment>> getEnrollmentsFor({final String username}) async {
    List<Enrollment> list = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.GET_ENROLLMENTS_FOR,
            body: json.encode({
              "student": username,
            }),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(seconds: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            final dynamic body = json.decode(response.body);
            throw new Exception(body["msg"]);
          }

          return response;
        });

    final dynamic enrollments = (json.decode(response.body))["enrollments"];
    enrollments.forEach((final String k, final dynamic enroll) {
      list.add(Enrollment.fromJson(enroll[0]));
    });

    return list;
  }

  Future<List<Enrollment>> completeEnrollments(
      final List<Enrollment> enrollments, final String username) async {
    for (Enrollment enrollment in enrollments) {
      try {
        final Response response = await http
            .post(Constants.SERVER_ADDRESS + Constants.GET_ENROLLMENT_TYPE_AT,
                body: json.encode({
                  "student": username,
                  "teacher": enrollment.teacherName,
                  "courseName": enrollment.courseName
                }),
                headers: {"Content-Type": "application/json"})
            .catchError((err) =>
                throw new Exception("Could not get any response from server"));

        final dynamic rez = json.decode(response.body);

        enrollment.atCourse = rez["atCourse"];
        enrollment.atLaboratory = rez["atLaboratory"];
        enrollment.atSeminary = rez["atSeminar"];

      } on Exception {
        print('Exception');
      }
    }

    return enrollments;
  }

  factory EnrollmentService() {
    return _instance;
  }

  static EnrollmentService _instance = new EnrollmentService._();
}
