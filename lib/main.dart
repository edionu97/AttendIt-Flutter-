import 'package:attend_it/home_screen/home_screen.dart';
import 'package:attend_it/login_screen/component.dart';
import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    title: "AttendIt",
    home: AppScreen(),
  );

  runApp(app);
  return;
}

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HomeScreen(username: "edi",)
    );
  }
}
