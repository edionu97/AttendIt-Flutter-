import 'package:flutter/material.dart';

class UploadVideoAttendance extends StatefulWidget {
  @override
  _UploadVideoAttendanceState createState() => _UploadVideoAttendanceState();
}

class _UploadVideoAttendanceState extends State<UploadVideoAttendance> {
  @override
  Widget build(BuildContext context) {
    return  Container(
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
    );
  }
}
