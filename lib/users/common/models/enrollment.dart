import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Enrollment {
  Enrollment(
      {this.enrollmentId,
      this.group,
      this.date,
      this.courseName,
      this.courseType,
      this.abbreviation,
      this.teacherName});

  factory Enrollment.fromJson(final Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return new Enrollment(
      group: json["group"],
      enrollmentId: json["enrollmentId"],
      date: json["enrollmentDate"],
      courseName: json["course"]["name"],
      courseType: json["course"]["type"],
      abbreviation: json["course"]["abbreviation"],
      teacherName: json["course"]["user"]["usern"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "enrollmentId": enrollmentId,
      "group": group,
      "date": date,
      "courseName": courseName,
      "courseType": courseType,
      "abbreviation": abbreviation
    };
  }

  bool atCourse;
  bool atSeminary;
  bool atLaboratory;

  final int enrollmentId;
  final String group;
  final String date;
  final String courseName;
  final String teacherName;
  final String courseType;
  final String abbreviation;
}
