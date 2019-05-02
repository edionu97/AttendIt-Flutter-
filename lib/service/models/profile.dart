import 'dart:convert';

import 'package:flutter/material.dart';

class Profile {

  Profile({this.email, this.first, this.last, this.phone, this.image});

  static Profile fromJSON(dynamic json) {

    if(json == null){
      return null;
    }

    return new Profile(
        email: json["email"],
        first: json["first"],
        last: json["last"],
        phone: json["phone"],
        image: Image.memory(
            base64.decode(json["image"].toString().split(",")[1])));
  }

  final String email;
  final String first;
  final String last;
  final String phone;
  final Image image;
}
