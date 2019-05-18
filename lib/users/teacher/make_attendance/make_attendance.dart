import 'package:attend_it/users/teacher/utils/select_course/select_course.dart';
import 'package:attend_it/users/teacher/utils/select_group/select_group.dart';
import 'package:flutter/material.dart';

class MakeAttendance extends StatefulWidget {

  MakeAttendance({this.username});

  @override
  _MakeAttendanceState createState() => _MakeAttendanceState();

  final String username;
}

class _MakeAttendanceState extends State<MakeAttendance> {

  @override
  void initState(){
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SelectCourse(username: widget.username,),
            SelectGroup(username: widget.username,)
          ],
        ));
  }

}
