import 'package:attend_it/users/common/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Course {
  Course({this.name, this.type, this.user, this.abbreviation=""});

  factory Course.fromJson(final Map<String, dynamic> json) {

    if(json == null){
      return null;
    }

    return new Course(
        name: json["name"], type: json["type"], user: User.fromJson(json["user"]), abbreviation: json["abbreviation"]);
  }

  Map<String, dynamic> toJson(){
      return {
        "name": name,
        "type": type,
        "user": user.toJson(),
        "abbreviation": abbreviation
      };
  }

  final String name;
  final String type;
  final User user;
  final String abbreviation;
}
