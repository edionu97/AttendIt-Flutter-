import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({this.controllerCamera, this.onFinish, this.tmpFileName, this.stopTime = 11 * 1000});

  @override
  _VideoScreenState createState() => _VideoScreenState();

  final CameraController controllerCamera;
  final Function onFinish;
  final String tmpFileName;
  final int stopTime;
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: widget.controllerCamera.value.isInitialized
                      ? CameraPreview(widget.controllerCamera)
                      : Container(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Opacity(
                      opacity: .5,
                      child: Container(
                        height: 30,
                        width: 70,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _timerClocks != null ? "00:${(_timerClocks.tick ~/ 10)}${_timerClocks.tick % 10}" : "00:00",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        splashColor: Colors.lightGreen,
                        onTap: () => _finishRecording(),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        ),
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
    final File tmpFile = new File(tmpDirectory.path + widget.tmpFileName);
    if (tmpFile.existsSync()) {
      tmpFile.deleteSync();
    }

    await widget.controllerCamera.startVideoRecording(tmpFile.path);
    _controller.forward();

    _timer = Timer(Duration(milliseconds: widget.stopTime), (){
      _finishRecording();
    });

    _timerClocks = Timer.periodic(const Duration(milliseconds: 1000), (timer){
      setState(() {
      });
    });
    setState(() {});
  }

  Future<void> _finishRecording() async {

    if(_timer.isActive){
      _timer.cancel();
    }

    if(_timerClocks.isActive){
      _timerClocks.cancel();
    }

    widget.controllerCamera.stopVideoRecording();
    _controller.reverse().then((_) => widget.onFinish());
  }

  AnimationController _controller;
  Animation<Offset> _animation;
  Timer _timer;
  Timer _timerClocks;
}
