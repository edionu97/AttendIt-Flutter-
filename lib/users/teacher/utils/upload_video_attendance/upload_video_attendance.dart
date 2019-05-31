import 'dart:io';
import 'dart:math';

import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/student/service/attendance_service.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/video_screen/component.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UploadVideoAttendance extends StatefulWidget {
  UploadVideoAttendance(
      {@required this.course, @required this.cls, this.enrolled = 0});

  @override
  _UploadVideoAttendanceState createState() => _UploadVideoAttendanceState();

  final Course course;
  final String cls;
  final int enrolled;
}

class _UploadVideoAttendanceState extends State<UploadVideoAttendance> {
  @override
  void dispose() {
    if (cameraController != null) {
      cameraController.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._initializeCameras();
  }

  Future<void> _initializeCameras() async {
    final Directory directory = await getTemporaryDirectory();
    final File fileAttendance =
        new File(directory.path + Constants.TMP_ATTENDANCE);

    if (fileAttendance.existsSync()) {
      fileAttendance.deleteSync();
    }

    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(20));

    return Material(
      elevation: 15,
      borderRadius: radius,
      child: Container(
        height: 250,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _createFields(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: Offset(11, -20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: InkWell(
                    onTap: () => this._uploadVideo(context),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.group,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.grey[300],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: InkWell(
                    splashColor: Colors.grey,
                    onTap: () => this.__showCameraDialog(context),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 15,
          child: Text(
            "Attendance overview",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45),
          ),
        ),
        Divider(
          height: 1,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Students enrolled",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.enrolled.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: widget.enrolled != 0 ? Colors.black : Colors.red),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Selected course",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.course != null
                  ? widget.course.abbreviation.toUpperCase()
                  : "",
              textAlign: TextAlign.left,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Selected grup",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.cls == null ? "" : widget.cls,
              textAlign: TextAlign.left,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Selected course type",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.course != null ? widget.course.type : "",
              textAlign: TextAlign.left,
            )
          ],
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  void __showCameraDialog(final BuildContext cont) {
    GUI.chooseCamera(
        context: cont,
        afterOpen: (final int camIdx) {
          if (cameraController != null) {
            cameraController.dispose();
          }

          cameraController = CameraController(
              cameras[min(camIdx, cameras.length)], ResolutionPreset.high);

          showDialog(
              context: cont,
              builder: (context) => Container(
                    color: Colors.transparent,
                    child: VideoScreen(
                      controllerCamera: cameraController,
                      tmpFileName: Constants.TMP_ATTENDANCE,
                      onFinish: () {
                        if (Navigator.canPop(cont)) {
                          Navigator.of(cont).pop();
                        }
                        Future.delayed(
                                Duration.zero, () => cameraController.dispose())
                            .then((_) => print('done'));
                      },
                    ),
                  ));
        });
  }

  void _uploadVideo(final BuildContext context) async {
    // check if the class is set
    if (widget.enrolled == 0) {
      GUI.openDialog(
        context: context,
        message: "There are no students enrolled at course",
      );
      return;
    }

    final Directory directory = await getTemporaryDirectory();
    final File fileAttendance =
        new File(directory.path + Constants.TMP_ATTENDANCE);

    if (!fileAttendance.existsSync()) {
      GUI.openDialog(
        context: context,
        message: "You must upload a video with class",
      );
      return;
    }

    try {
      await AttendanceService().uploadAttendanceVideo(
          file: fileAttendance,
          teacher: widget.course.user.username,
          cls: widget.cls,
          courseName: widget.course.name,
          courseType: widget.course.type);
      GUI.openDialog(
          context: context,
          message: "Video successfully uploaded",
          iconData: Icons.check,
          iconColor: Colors.green,
          title: "Success");
    } on Exception catch (e) {
      GUI.openDialog(
        context: context,
        message: e.toString(),
      );
    }
  }

  List<CameraDescription> cameras;
  CameraController cameraController;
}
