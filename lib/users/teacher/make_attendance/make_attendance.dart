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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(
                "user.jpg",
                filterQuality: FilterQuality.high,
              ).image,
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SelectCourse(
                username: widget.username,
              ),
              SelectGroup(
                username: widget.username,
              )
            ],
          ),
          Transform.translate(
            offset: Offset(0, 80),
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Transform.translate(
                offset: Offset(0, -125),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage("user.png"))
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
