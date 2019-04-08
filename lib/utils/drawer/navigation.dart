import 'package:flutter/material.dart';

class NavigationModel {

  NavigationModel({this.title, this.icon});

  final String title;
  final IconData icon;
}

List<NavigationModel> navigationOptions = [
  NavigationModel(title: "Home", icon: Icons.home),
  NavigationModel(title: "Video", icon: Icons.camera),
  NavigationModel(title: "Settings", icon: Icons.settings),
];
