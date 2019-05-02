import 'package:attend_it/service/models/profile.dart';

class User {

  User({this.role, this.profile, this.username});

  static User fromJSON(dynamic json){

    if(json == null){
      return null;
    }

    return new User(
      role: json["role"],
      username: json["usern"],
      profile: Profile.fromJSON(json["profile"])
    );
  }

  final String role;
  final Profile profile;
  final String username;

}
