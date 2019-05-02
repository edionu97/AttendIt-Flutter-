import 'package:attend_it/service/models/user.dart';

class Course {
  Course({this.name, this.type, this.user});

  static Course fromJSON(dynamic json) {

    if(json == null){
      return null;
    }

    return new Course(
        name: json["name"], type: json["type"], user: User.fromJSON(json["user"]));
  }

  final String name;
  final String type;
  final User user;
}
