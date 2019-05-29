import 'dart:convert';

import 'package:attend_it/users/common/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HistoryInfo {
  HistoryInfo(
      {this.historyId,
      this.group,
      this.teacherName,
      this.attendanceImage,
      this.attendanceDate,
      this.courseName,
      this.courseType,
      this.courseAbr,
      this.studentName,
      this.role,
      this.studentProfile});

  factory HistoryInfo.fromJson(final Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return new HistoryInfo(
        historyId: json["historyId"],
        group: json["grp"],
        teacherName: json["teacherName"],
        attendanceImage: json["attendanceImage"] != null
            ? Image.memory(base64.decode(json["attendanceImage"]))
            : null,
        attendanceDate: DateTime.parse(json["attendanceDate"]),
        courseType: json["courseType"],
        courseName: json["courseName"],
        courseAbr: json["courseAbr"],
        studentName: json["studentName"],
        role: json["role"],
        studentProfile: json["studentProfile"] == null
            ? null
            : Profile.fromJson(json["studentProfile"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "historyId": historyId,
      "grp": group,
      "teacherName": teacherName,
      "attendanceImage": attendanceImage,
      "attendanceDate": attendanceDate,
      "courseType": courseType,
      "courseName": courseName,
      "courseAbr": courseAbr,
      "studentName": studentName,
      "role": role,
      "studentProfile": studentProfile
    };
  }

  final int historyId;
  final String group;
  final String teacherName;
  final Image attendanceImage;
  final DateTime attendanceDate;
  final String courseName;
  final String courseType;
  final String courseAbr;
  final String studentName;
  final String role;
  final Profile studentProfile;
}
