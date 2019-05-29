import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class History {
  History({this.historyId, this.group, this.teacherName, this.image});

  factory History.fromJson(final Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return new History(
        historyId: json["historyId"],
        group: json["grp"],
        teacherName: json["teacherName"],
        image: json["attendanceImage"] != null
            ? Image.memory(base64.decode(json["attendanceImage"]))
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      "historyId": historyId,
      "grp": group,
      "teacherName": teacherName,
      "image": image
    };
  }

  final int historyId;
  final String group;
  final String teacherName;
  final Image image;
}
