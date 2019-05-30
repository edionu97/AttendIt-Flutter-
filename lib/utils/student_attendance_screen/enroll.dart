import 'dart:convert';

import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/student/service/enrollment_service.dart';
import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/profile.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:flutter/material.dart';

class Enroll extends StatefulWidget {
  Enroll({@required this.course, @required this.username});

  @override
  _EnrollState createState() => _EnrollState();

  void hide() {
    if (list.isEmpty) {
      return;
    }

    final _EnrollState _enrollState = list[0];
    _enrollState.hide();
  }

  final Course course;
  final String username;
  final List<_EnrollState> list = [];
}

class _EnrollState extends State<Enroll> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!this.mounted) {
        return;
      }
      setState(() {});
    });

    widget.list.add(this);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(_animationController);

    _animation1 = new Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    _checkEnrollment();

    Notificator().addObserver(this._notified);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _animationController.dispose();
    _editingController.dispose();
    Notificator().removeObserver(this._notified);
    super.dispose();
  }

  void hide() {
    _animationController.reverse().then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context, widget),
    );
  }

  Widget _getWidget(final BuildContext context, final Widget wid) {
    return SingleChildScrollView(
      padding: focusNode.hasFocus
          ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          : EdgeInsets.only(bottom: 0),
      child: FadeTransition(
        opacity: _animation1,
        child: SlideTransition(
          position: _animation2,
          child: Opacity(
            opacity: 0.94,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                height: 200,
                width: MediaQuery.of(context).size.width,
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
    );
  }

  Widget _firstPart(final BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5, left: 5),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: _getListImage(widget.course),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _getLabelTextPair(
                              "Teacher name", _getSubtitle(widget.course).data),
                          Divider(
                            height: 5,
                          ),
                          widget.course.user.profile != null
                              ? _getLabelTextPair(
                                  "Phone", widget.course.user.profile.phone)
                              : Container(),
                          Divider(
                            height: 5,
                          ),
                          widget.course.user.profile != null
                              ? _getLabelTextPair(
                                  "Email", widget.course.user.profile.email)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                _isEnrolled != null
                    ? Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: !_isEnrolled
                                  ? () {}
                                  : () => this._cancelEnroll(context),
                              child: Image(
                                image: AssetImage("remove.png"),
                                color: !_isEnrolled ? Colors.grey : Colors.red,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Divider(
                              height: 10,
                            ),
                            Container(
                              child: InkWell(
                                onTap: _isEnrolled
                                    ? () {}
                                    : () => this._enroll(context),
                                child: Image(
                                  image: AssetImage("add.png"),
                                  color:
                                      _isEnrolled ? Colors.grey : Colors.green,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            Form(
                              key: _key,
                              child: _isEnrolled
                                  ? Container()
                                  : Container(
                                      width: 80,
                                      height: 50,
                                      child: TextFormField(
                                        focusNode: focusNode,
                                        controller: _editingController,
                                        validator: (val) {
                                          if (val.isEmpty || val == " ") {
                                            return "";
                                          }
                                        },
                                        decoration: new InputDecoration(
                                            labelText: "Enter group",
                                            fillColor: Colors.white),
                                        keyboardType: TextInputType.text,
                                        style: new TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14),
                                      )),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
            Divider(
              height: 10,
              color: Colors.blueGrey,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: _getLabelTextPair(
                            "Course type", widget.course.type,
                            alignment: Alignment.center)),
                    Flexible(
                        child: _getLabelTextPair(
                            "Course name", widget.course.name,
                            alignment: Alignment.center)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLabelTextPair(final String label, final String text,
      {Alignment alignment = Alignment.topLeft}) {
    return Column(
      children: <Widget>[
        Align(
            alignment: alignment,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        Divider(
          height: 2,
        ),
        Align(
            alignment: alignment,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            )),
      ],
    );
  }

  ImageProvider _getListImage(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  Text _getSubtitle(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return Text("User: ${course.user.username}");
    }

    return Text("${course.user.profile.first} ${course.user.profile.last}");
  }

  void _checkEnrollment() async {
    bool _isEnrolled = false;
    try {
      _isEnrolled =
          await EnrollmentService().isEnrolled(widget.course, widget.username);
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!this.mounted) {
      return;
    }

    setState(() {
      this._isEnrolled = _isEnrolled;
    });
  }

  void _enroll(final BuildContext context) async {
    if (!_key.currentState.validate()) {
      return;
    }

    _editingController.text = _editingController.text.trim();
    final String _text = _editingController.text;

    try {
      await EnrollmentService().enroll(
          username: widget.username, group: _text, course: widget.course);
      Notificator().sendOnlyTo([
        widget.username,
        widget.course.user.username
      ], {
        "type": NotificationType.STUDENT_ENROLLED.toString(),
        "data": {
          "usern": widget.username,
          "course": widget.course,
          "group": _text
        }
      });
    } on Exception catch (e) {
      print(e.toString());
      GUI.openDialog(context: context, message: e.toString());
    }
  }

  void _cancelEnroll(final BuildContext context) async {
    GUI.yesNoDialog(
        context: context,
        afterOpen: () async {
          try {
            await EnrollmentService()
                .cancelEnrollment(widget.username, widget.course);
            Notificator().sendOnlyTo([
              widget.username,
              widget.course.user.username
            ], {
              "type": NotificationType.STUDENT_ENROLL_CANCELED.toString(),
              "data": {"usern": widget.username, "course": widget.course}
            });
          } on Exception catch (e) {
            GUI.openDialog(context: context, message: e.toString());
          }
        });
  }

  void _notified(final dynamic notification) {
    final NotificationType type =
        getNotificationTypeFromString(notification["type"]);

    switch (type) {
      case NotificationType.STUDENT_ENROLLED:
        if (!this.mounted) {
          return;
        }
        setState(() {
          _isEnrolled = true;
        });
        break;
      case NotificationType.STUDENT_ENROLL_CANCELED:
        if (!this.mounted) {
          return;
        }
        setState(() {
          _isEnrolled = false;
        });
        break;
      default:
        break;
    }
  }

  bool _isEnrolled;
  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  final FocusNode focusNode = new FocusNode();
  final TextEditingController _editingController =
      new TextEditingController(text: " ");
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
}
