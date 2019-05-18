import 'dart:convert';

import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/enrollment.dart';
import 'package:attend_it/users/common/models/user.dart';
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

  Future<dynamic> addCourse(final String teacherName, final String courseName,
      final String courseType, final String courseAbr) async {
    return http
        .post(Constants.SERVER_ADDRESS + Constants.ADD_COURSE,
            body: json.encode({
              "teacher": teacherName,
              "courseName": courseName,
              "courseType": courseType.toUpperCase(),
              "abr": courseAbr
            }),
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
  }

  Future<Course> findCourse(final String teacher, final String courseName,
      final String courseType) async {
    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.FIND_BY,
            body: json.encode({
              "teacher": teacher,
              "courseName": courseName,
              "courseType": courseType.toUpperCase(),
            }),
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

    final dynamic courseJson = json.decode(response.body);
    return Course.fromJson(courseJson["course"]);
  }

  Future<List<User>> getEnrollmentsAtCourse(final String teacher,
      final String courseName, final String courseType) async {
    final List<User> list = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.GET_COURSE_ENROLLMENTS,
            body: json.encode({
              "teacher": teacher,
              "courseName": courseName,
              "courseType": courseType.toUpperCase()
            }),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
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
    enrollments.forEach((enrollment) {
      list.add(User.fromJson(enrollment["user"]));
    });

    return list;
  }


  Future<List<String>> getDistinctClasses(
      final String teacherName) async {
    final List<String> classes = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.GET_GROUPS_ENROLLED,
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

    final dynamic _classes = (json.decode(response.body))["classes"];
    _classes.forEach((final dynamic cls) => classes.add(cls));

    return classes;
  }

  static final CourseService _instance = CourseService._();
}
