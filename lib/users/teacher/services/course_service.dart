import 'dart:convert';

import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/utils/constants/constants.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CourseService {
  CourseService._();

  factory CourseService() {
    return _instance;
  }

  Future<List<Course>> getCoursesPostedByTeacher(
      final String teacherName) async {
    final List<Course> courses = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.GET_MY_COURSES,
            body: json.encode({"usern": teacherName}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 2))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            throw new Exception(json.decode(response.body)["msg"]);
          }
          return response;
        });

    final dynamic _courses = (json.decode(response.body))["courses"];

    _courses.forEach(
        (dynamic courseJson) => courses.add(Course.fromJson(courseJson)));

    return courses;
  }

  static final CourseService _instance = CourseService._();
}
