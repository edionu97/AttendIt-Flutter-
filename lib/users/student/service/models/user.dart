import 'package:attend_it/users/student/service/models/profile.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {

  User({this.role, this.profile, this.username});

  factory User.fromJson(Map<String, dynamic> json){

    if(json == null){
      return null;
    }

    return new User(
      role: json["role"],
      username: json["usern"],
      profile: Profile.fromJson(json["profile"])
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "role": role,
      "usern": username,
      "profile": profile.toJson()
    };
  }

  String role;
  final Profile profile;
  final String username;

}
