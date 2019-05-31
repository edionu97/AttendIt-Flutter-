
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Attendance{

  Attendance({this.attendanceId, this.attendanceDate});

  factory Attendance.fromJson(final Map<String, dynamic> json) {

    if(json == null){
      return null;
    }

    return new Attendance(
      attendanceId:  json["attendanceId"],
      attendanceDate: DateTime.parse(json["attendanceDate"].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "attendanceId": attendanceId,
      "attendanceDate": attendanceDate
    };
  }

  final int attendanceId;
  final DateTime attendanceDate;
}