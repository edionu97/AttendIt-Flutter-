
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class StudentAttendanceScreen extends StatefulWidget {

  StudentAttendanceScreen({this.username});

  @override
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();


  final String username;
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Loader(),
        ),
      ),
    );
  }
}

