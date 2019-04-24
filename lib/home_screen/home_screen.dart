import 'dart:io';
import 'dart:math';

import 'package:attend_it/login_screen/component.dart';
import 'package:attend_it/main.dart';
import 'package:attend_it/navigation_drawer/component.dart';
import 'package:attend_it/notifications/notificator.dart';
import 'package:attend_it/profile_screen/component.dart';
import 'package:attend_it/service/profile_service.dart';
import 'package:attend_it/upload_video_screen/component.dart';
import 'package:attend_it/utils/components/animation.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/video_screen/component.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();

  final String username;
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widgetController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    controllerDrawer = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    widgetAnimation = Tween<double>(begin: 0, end: 1).animate(widgetController);

    drawerAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(controllerDrawer);

    widgets = [
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Homescreen",
                style: TextStyle(fontSize: 20),
              ),
            )),
      ),
      Container(),
      Container(),
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Profile(username: widget.username)),
      ),
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Attendence screen",
                style: TextStyle(fontSize: 20),
              ),
            )),
      )
    ];

    _initializeCameras();
    widgetController.forward();
    Notificator().setOnDone(() => _restartApp());
  }

  @override
  void dispose() {
    super.dispose();
    widgetController.dispose();
    controllerDrawer.dispose();

    if (cameraController != null) {
      cameraController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        InkWell(
            onTap: () {
              if (!_isDrawerVisible) {
                return;
              }
              controllerDrawer.reverse().then((f) => setState(() {
                    _isDrawerVisible = false;
                  }));
            },
            child: widgets[_selectedItem]),
        _isDrawerVisible ? _getNavigationDrawer() : _getNavigationDrawerButton()
      ],
    ));
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
  }

  void _selection(final int index, final BuildContext context) {
    switch (index) {
      case 1:
        {
          _showCameraDialog(context);
          setState(() {
            _isDrawerVisible = false;
          });
          break;
        }

      case 2:
        {
          _logoutAction(context);
          break;
        }

      default:
        {
          widgetController.reverse().then((f) {
            widgetController.forward();
            setState(() {
              _isDrawerVisible = false;
              _selectedItem = index;
            });
          });
        }
    }
  }

  void _showCameraDialog(final BuildContext cont, {int index = 0}) {
    showDialog(
        context: cont,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              // container to set color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    __getDialog(index, cont),
                    Divider(
                      height: 5,
                    )
                  ]));
        });
  }

  void _logoutAction(final BuildContext context) {
    Navigator.of(context).pop();
    Notificator().setOnDone((_){});
    Notificator().close();
  }

  void _restartApp(){
    Notificator().close();
    RestartWidget.restartApp(context);
  }

  Widget _getNavigationDrawerButton() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(top: 35, left: 15),
          child: InkWell(
            onTap: () {
              setState(() {
                controllerDrawer.reset();
                controllerDrawer.forward();
                _isDrawerVisible = !_isDrawerVisible;
              });
            },
            child: Icon(
              Icons.menu,
              size: 35,
            ),
          ),
        ));
  }

  Widget _getNavigationDrawer() {
    return Align(
      alignment: Alignment.topLeft,
      child: SlideTransition(
        position: drawerAnimation,
        child: NavigationDrawer(
            username: widget.username,
            selected: _selectedItem,
            selectionHandler: (idx) => controllerDrawer
                .reverse()
                .then((f) => _selection(idx, context)),
            onClose: () => controllerDrawer.reverse().then(
                (f) => setState(() => _isDrawerVisible = !_isDrawerVisible))),
      ),
    );
  }

  Widget __getDialog(final int index, final BuildContext context) {
    final String assetImage =
        index == 0 ? "head_left_right.gif" : "head_up_down.gif";
    final String text = index == 0
        ? Constants.TILT_HEAD_LEFT_RIGHT
        : Constants.TILT_HEAD_UP_DOWN;

    return Video(
      assertImage: assetImage,
      onClickGotIt: () {
        Navigator.of(context).pop();
        __showCameraDialog(index, context);
      },
      text: text,
    );
  }

  Future<void> _uploadFiles(final BuildContext context) async {
    try {
      await profileService.uploadVideoRecords(widget.username);
      GUI.openDialog(
          context: context,
          message: "Videos successfully uploaded",
          title: "Success",
          iconData: Icons.check,
          iconColor: Colors.green);
    } on Exception catch (e) {
      GUI.openDialog(
          context: context,
          message: e.toString().split("")[1],
          title: "Success");
    }

    new File((await getTemporaryDirectory()).path + Constants.TMP_LEFT_RIGHT)
        .deleteSync();
    new File((await getTemporaryDirectory()).path + Constants.TMP_UP_DOWN)
        .deleteSync();
  }

  void __showCameraDialog(final int index, final BuildContext cont) {
    final String tmpFileName =
        index == 0 ? Constants.TMP_LEFT_RIGHT : Constants.TMP_UP_DOWN;

    GUI.chooseCamera(
        context: cont,
        afterOpen: (final int camIdx) {
          cameraController = CameraController(
              cameras[min(camIdx, cameras.length)], ResolutionPreset.high);

          showDialog(
              context: cont,
              builder: (context) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    child: VideoScreen(
                      controllerCamera: cameraController,
                      tmpFileName: tmpFileName,
                      onFinish: () {
                        Navigator.of(cont).pop();
                        Future.delayed(
                                Duration.zero, () => cameraController.dispose())
                            .then((_) => index == 0
                                ? _showCameraDialog(cont, index: 1)
                                : _uploadFiles(cont));
                      },
                    ),
                  ));
        });
  }

  bool _isDrawerVisible = false;
  int _selectedItem = 0;
  List<Widget> widgets;

  AnimationController widgetController;
  AnimationController controllerDrawer;
  Animation<double> widgetAnimation;
  Animation<Offset> drawerAnimation;
  CameraController cameraController;

  List<CameraDescription> cameras;
  final ProfileService profileService = ProfileService();
}
