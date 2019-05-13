import 'package:flutter/material.dart';

class NavigationModel {

  NavigationModel({this.title, this.icon});

  final String title;
  final IconData icon;
}

final List<NavigationModel> navigationOptionsStudent = [
  NavigationModel(title: "Home", icon: Icons.home),
  NavigationModel(title: "Video", icon: Icons.camera),
  NavigationModel(title: "Logout", icon: Icons.power_settings_new),
  NavigationModel(title: "Settings", icon: Icons.settings),
  NavigationModel(title: "Attendence", icon: Icons.people),
];

final List<NavigationModel> navigationOptionsTeacher = [
  NavigationModel(title: "Attendances", icon: Icons.person_add),
  NavigationModel(title: "Presence", icon: Icons.youtube_searched_for),
  NavigationModel(title: "Logout", icon: Icons.power_settings_new),
  NavigationModel(title: "Settings", icon: Icons.settings),
  NavigationModel(title: "Course", icon: Icons.add_circle_outline),
  NavigationModel(title: "My courses", icon: Icons.insert_invitation),
];
