import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Profile {

  Profile({this.email, this.first, this.last, this.phone, this.image});

  factory Profile.fromJson(final Map<String, dynamic> json) {

    if(json == null){
      return null;
    }

    return new Profile(
        email: json["email"],
        first: json["first"],
        last: json["last"],
        phone: json["phone"],
        image: json["image"] != null ? Image.memory(
            base64.decode(json["image"].toString().split(",")[1])) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "first": first,
      "last": last,
      "phone": phone
    };
  }

  final String email;
  final String first;
  final String last;
  final String phone;
  final Image image;
}
