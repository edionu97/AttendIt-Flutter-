import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/teacher/utils/select_course/select_course.dart';
import 'package:attend_it/users/teacher/utils/select_group/select_group.dart';
import 'package:attend_it/users/teacher/utils/upload_video_attendance/upload_video_attendance.dart';
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
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SelectCourse(
                username: widget.username,
                courseSelected: (final Course crs) {
                  if(!this.mounted){
                    return;
                  }
                  setState(() {
                    selectedCourse = crs;
                  });
                },
              ),
              SelectGroup(
                username: widget.username,
                classClicked: (final String cls){
                  if(!this.mounted){
                    return;
                  }
                  setState(() {
                    selectedClass = cls;
                  });
                },
              )
            ],
          ),
          UploadVideoAttendance(course: selectedCourse, cls: selectedClass)
        ],
      ),
    ));
  }

  Course selectedCourse;
  String selectedClass;
}
