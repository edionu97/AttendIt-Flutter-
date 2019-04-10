import 'dart:io';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({this.controllerCamera, this.onFinish});

  @override
  _VideoScreenState createState() => _VideoScreenState();

  final CameraController controllerCamera;
  final Function onFinish;
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(_controller);

    __initVideoRecording();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, widget) => _getWidget(context),
    );
  }

  Widget _getWidget(final BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Material(
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: widget.controllerCamera.value.isInitialized
                      ? CameraPreview(widget.controllerCamera)
                      : Container(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: InkWell(
                      onTap: () => _finishRecording(context),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Future<void> __initVideoRecording() async {
    await widget.controllerCamera.initialize();

    final Directory tmpDirectory = await getTemporaryDirectory();
    final File tmpFile = new File(tmpDirectory.path + Constants.TMP_LEFT_RIGHT);
    if (tmpFile.existsSync()) {
      tmpFile.deleteSync();
    }

    await widget.controllerCamera.startVideoRecording(tmpFile.path);
    _controller.forward();
    setState(() {});
  }

  Future<void> _finishRecording(final BuildContext context) async {
    widget.controllerCamera.stopVideoRecording();
    _controller.reverse().then((_) => widget.onFinish());
  }

  AnimationController _controller;
  Animation<Offset> _animation;
}
