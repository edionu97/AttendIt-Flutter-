import 'package:attend_it/users/teacher/models/history_info.dart';
import 'package:attend_it/users/teacher/utils/present_students/component.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/components/dragable_sidebar.dart';
import 'package:attend_it/utils/components/draggable_left_sidebar.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class AttendanceInfo extends StatefulWidget {
  AttendanceInfo({this.historyInfo, this.username});

  @override
  _AttendanceInfoState createState() => _AttendanceInfoState();

  void hide() {
    if (list.length == 0) {
      return;
    }

    final _AttendanceInfoState _attendanceInfoState = list[0];
    _attendanceInfoState.hide();
  }

  final HistoryInfo historyInfo;
  final String username;
  final List<_AttendanceInfoState> list = [];
}

class _AttendanceInfoState extends State<AttendanceInfo>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.list.add(this);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(_animationController);

    _animation1 = new Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    attendantStudentsAbsent = new AttendantStudents(
      historyInfo: widget.historyInfo,
      username: widget.username,
      isAbsent: true,
    );

    attendantStudentsPresent = new AttendantStudents(
      historyInfo: widget.historyInfo,
      username: widget.username,
      isAbsent: false,
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context, widget),
    );
  }

  Widget _getWidget(final BuildContext context, final Widget wid) {
    return GestureDetector(
      onDoubleTap: () {
        _animationController.reverse().then((_) => Navigator.of(context).pop());
      },
      child: FadeTransition(
        opacity: _animation1,
        child: ScaleTransition(
          scale: _animation1,
          child: SlideTransition(
            position: _animation2,
            child: Opacity(
              opacity: 0.94,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: 250,
                  decoration: Decorator.getDialogDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _firstPart(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstPart(final BuildContext context) {
    return Expanded(
        child: _isLoading
            ? Center(
                child: Loader(),
              )
            : _createView(context));
  }

  Widget _createView(final BuildContext context) {
    final BorderRadius borderRadius = new BorderRadius.all(
      Radius.circular(30),
    );

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(borderRadius: borderRadius, color: Colors.grey),
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: !_isVisible
                            ? DecorationImage(
                                image: widget.historyInfo.attendanceImage.image,
                                fit: BoxFit.fill)
                            : null,
                        borderRadius: borderRadius),
                    child: _isVisible
                        ? Container(
                            decoration:
                                BoxDecoration(borderRadius: borderRadius),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: this.__attendanceResult(context))
                        : Container()),
                Transform.translate(
                  offset: Offset(10, 10),
                  child: RoundBorderButton(
                    onTap: () => this._buttonVisiblePressed(context),
                    buttonColor: !_isVisible ? Colors.grey : Colors.white,
                    iconColor: Colors.black87,
                    splashColor: !_isVisible ? Colors.white : Colors.grey,
                    iconSize: 15,
                    height: 20,
                    weight: 20,
                    buttonIcon:
                        !_isVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                _isVisible
                    ? DraggableLeftSideBar(draggedInside: _dataDraggedIn)
                    : Container(),
                _isVisible
                    ? DraggableSideBar(
                        draggableInfo: _dataDraggedIn,
                      )
                    : Container(),
                _isVisible
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Material(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            elevation: 5,
                            child: Container(
                              height: 20,
                              width: 210,
                              child: Center(
                                child: Text(
                                  "Attendance status class ${widget.historyInfo.group}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _dataDraggedIn(data) {
    final List<String> list = data.toString().split(":");
    final String username = list[1].trim();

    if (list[0].trim() == "Absent") {
      final HistoryInfo historyInfo =
          attendantStudentsAbsent.getHistoryInfo(username);

      if (historyInfo == null) {
        return;
      }
      attendantStudentsPresent.addHistoryInList(historyInfo);
      attendantStudentsAbsent.removeHistoryInfo(username);
      return;
    }

    final HistoryInfo historyInfo =
        attendantStudentsPresent.getHistoryInfo(username);

    if (historyInfo == null) {
      return;
    }
    attendantStudentsPresent.removeHistoryInfo(username);
    attendantStudentsAbsent.addHistoryInList(historyInfo);
  }

  void hide() {
    _animationController.reverse().then((_) => Navigator.of(context).pop());
  }

  void _buttonVisiblePressed(final BuildContext context) {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Widget __attendanceResult(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        attendantStudentsAbsent,
        attendantStudentsPresent
      ],
    );
  }

  AttendantStudents attendantStudentsPresent;
  AttendantStudents attendantStudentsAbsent;

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  bool _isLoading = false;
  bool _isVisible = true;
}
