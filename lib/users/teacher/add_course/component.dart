import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/common/service/profile_service.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:flutter/material.dart';

class AddCourse extends StatefulWidget {
  AddCourse({this.username});

  @override
  _State createState() => _State();

  void hide() {
    if (list.isEmpty) {
      return;
    }

    final _State _addCourse = list[0];
    _addCourse.hide();
  }

  final List<_State> list = [];
  final String username;
}

class _State extends State<AddCourse> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.list.add(this);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(_animationController);

    _animation1 = new Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    courseType.dispose();
    courseAbr.dispose();
    courseName.dispose();
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
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: FadeTransition(
        opacity: _animation1,
        child: SlideTransition(
          position: _animation2,
          child: Opacity(
            opacity: 0.9,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                height: MediaQuery.of(context).size.height / 2,
                width: 300,
                decoration: Decorator.getDialogDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Expanded(child: _createFields(context))],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createFields(final BuildContext context) {
    final BorderRadius buttonBorderRadius =
        BorderRadius.all(Radius.circular(20));

    return Form(
      key: _formKey,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Transform.translate(
                offset: Offset(30, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      elevation: 15,
                      borderRadius: buttonBorderRadius,
                      child: InkWell(
                        onTap: () => this._addPressed(context),
                        borderRadius: buttonBorderRadius,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: buttonBorderRadius,
                              border: Border.all(
                                  color: Colors.black38, width: .15)),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: courseName,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                    labelText: "Enter course name"),
                validator: (val) {
                  if (val.isEmpty) {
                    return "This field is mandatory";
                  }
                },
              ),
              TextFormField(
                controller: courseType,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.assessment,
                      color: Colors.black,
                    ),
                    labelText: "Enter course type"),
                validator: (val) {
                  if (val.isEmpty) {
                    return "This field is mandatory";
                  }
                  val = val.toLowerCase().trim();
                  print(val);
                  if (val != "seminar" &&
                      val != "laboratory" &&
                      val != "course") {
                    return "Only seminar, laboratory, course";
                  }
                },
              ),
              TextFormField(
                controller: courseAbr,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.textsms,
                      color: Colors.black,
                    ),
                    labelText: "Enter course abbreviation"),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This is a mandatory filed";
                  }
                  if (val.length > 5) {
                    return "You should insert maximum 5 leters";
                  }
                },
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black38),
                    icon: Icon(
                      Icons.person_outline,
                      color: Colors.black38,
                    ),
                    labelText: "Course added by user ${widget.username}"),
              ),
              Divider(
                height: 20,
              )
            ],
          )),
    );
  }

  void _addPressed(final BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    try {
      await CourseService().addCourse(
          widget.username, courseName.text, courseType.text, courseAbr.text);
      _afterSuccessAdd(context);
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  void _afterSuccessAdd(final BuildContext context) async {

    //close the window
    await _animationController
        .reverse();
    Navigator.of(context).pop();
    await Future.delayed(
        Duration.zero,
            () => GUI.openDialog(
            context: context,
            message: "Course successfully added",
            title: "Success",
            iconColor: Colors.green[900],
            iconData: Icons.check));

    Notificator().sendOnlyTo([widget.username], {
      "type": NotificationType.COURSE_ADDED_REFRESH.toString(),
      "data": {
        "course": {
          "name": courseName.text,
          "type": courseType.text,
          "teacher": widget.username
        }
      }
    });

    Notificator().sendToAll({
      "type": NotificationType.COURSE_ADDED.toString(),
      "data": {
        "course": {
          "name": courseName.text,
          "type": courseType.text,
          "teacher": widget.username
        }
      }
    });
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  final TextEditingController courseName = new TextEditingController();
  final TextEditingController courseType = new TextEditingController();
  final TextEditingController courseAbr = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
}
