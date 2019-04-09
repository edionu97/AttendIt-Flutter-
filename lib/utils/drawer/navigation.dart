import 'package:flutter/material.dart';

class NavigationModel {

  NavigationModel({this.title, this.icon});

  final String title;
  final IconData icon;
}

List<NavigationModel> navigationOptions = [
  NavigationModel(title: "Home", icon: Icons.home),
  NavigationModel(title: "Video", icon: Icons.camera),
  NavigationModel(title: "Logout", icon: Icons.power_settings_new),
  NavigationModel(title: "Settings", icon: Icons.settings),
  NavigationModel(title: "Attendence", icon: Icons.people),
];
