import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/student/service/enrollment_service.dart';
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
                courseSelected: (final Course crs) async {
                  if(!this.mounted){
                    return;
                  }
                  int resp = await EnrollmentService().getNoCourseGroup(course: crs, cls: selectedClass);
                  setState(() {
                    selectedCourse = crs;
                    enrolled = resp;
                  });
                },
              ),
              SelectGroup(
                username: widget.username,
                classClicked: (final String cls) async {
                  if(!this.mounted){
                    return;
                  }
                  int resp = await EnrollmentService().getNoCourseGroup(course: selectedCourse, cls: cls);
                  setState(() {
                    selectedClass = cls;
                    enrolled = resp;
                  });
                },
              )
            ],
          ),
          UploadVideoAttendance(course: selectedCourse, cls: selectedClass, enrolled: enrolled,)
        ],
      ),
    ));
  }

  Course selectedCourse;
  String selectedClass;
  int enrolled;
}
