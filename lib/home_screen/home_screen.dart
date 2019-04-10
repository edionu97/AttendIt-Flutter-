import 'dart:io';

import 'package:attend_it/navigation_drawer/component.dart';
import 'package:attend_it/profile_screen/component.dart';
import 'package:attend_it/service/profile_service.dart';
import 'package:attend_it/upload_video_screen/component.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    widgetController.dispose();
    controllerDrawer.dispose();
    cameraController.dispose();
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
          Navigator.pop(context);
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

  void _showCameraDialog(final BuildContext context, {int index = 0}) {
    final Widget widget = __getDialog(index, context);

    showDialog(
        context: context,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              // container to set color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    widget,
                    Divider(
                      height: 5,
                    )
                  ]));
        });
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
    switch (index) {
      case 0:
        {
          return Video(
            assertImage: "head_left_right.gif",
            onClickGotIt: () {
              _uploadLeftRight(index, context);
            },
            text: Constants.TILT_HEAD_LEFT_RIGHT,
          );
        }
      case 1:
        {
          return Video(
            assertImage: "head_up_down.gif",
            onClickGotIt: () {
              _uploadUpDown(index, context);
            },
            text: Constants.TILT_HEAD_UP_DOWN,
          );
        }
    }

    return null;
  }

  Future<void> _uploadLeftRight(
      final int index, final BuildContext cont) async {
    Navigator.of(context).pop();
    

    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    showDialog(
        context: cont,
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: VideoScreen(
                controllerCamera: cameraController,
                onFinish: () {
                  Navigator.of(context).pop();
                  Future.delayed(
                          Duration.zero, () => cameraController.dispose())
                      .then((_) => _uploadFile(cont));
                },
              ),
            ));
  }

  void _uploadUpDown(final int index, final BuildContext context) {}

  Future<void> _uploadFile(final BuildContext context) async {
    try {
      await profileService.uploadLeftRightVideoRecord(widget.username);
      GUI.openDialog(
          context: context,
          message: "Video successfully uploaded",
          title: "Success");
    } on Exception catch (e) {
      GUI.openDialog(
          context: context,
          message: e.toString().split("")[1],
          title: "Success");
    }
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
