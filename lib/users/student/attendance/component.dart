
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {

  Attendance({this.username});

  @override
  _AttendanceState createState() => _AttendanceState();

  final String username;
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
          child: Text("Check attendance screen"),
        ),
      ),
    );
  }
}
