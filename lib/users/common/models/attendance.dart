
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Attendance{

  Attendance({this.attendanceId, this.attendanceDate, this.attendanceTime});

  factory Attendance.fromJson(final Map<String, dynamic> json) {

    if(json == null){
      return null;
    }

    return new Attendance(
      attendanceId:  json["attendanceId"],
      attendanceDate: json["attendanceDate"].toString().split("T")[0],
      attendanceTime: json["attendanceDate"].toString().split("T")[1].split(".")[0],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "attendanceId": attendanceId,
      "attendanceDate": "${attendanceDate}T$attendanceTime"
    };
  }

  final int attendanceId;
  final String attendanceDate;
  final String attendanceTime;
}