import 'package:attend_it/users/student/service/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Course {
  Course({this.name, this.type, this.user});

  factory Course.fromJson(final Map<String, dynamic> json) {

    if(json == null){
      return null;
    }

    return new Course(
        name: json["name"], type: json["type"], user: User.fromJson(json["user"]));
  }

  Map<String, dynamic> toJson(){
      return {
        "name": name,
        "type": type,
        "user": user.toJson()
      };
  }

  final String name;
  final String type;
  final User user;
}
