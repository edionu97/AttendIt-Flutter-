import 'package:attend_it/main.dart';
import 'package:attend_it/users/common/navigation_drawer/component.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/common/profile_screen/component.dart';
import 'package:attend_it/users/teacher/make_attendance/make_attendance.dart';
import 'package:attend_it/users/teacher/my_courses/component.dart';
import 'package:attend_it/utils/drawer/navigation.dart';
import 'package:flutter/material.dart';

class HomeScreenTeacher extends StatefulWidget {
  HomeScreenTeacher({this.username});

  @override
  _HomeScreenTeacherState createState() => _HomeScreenTeacherState();

  final String username;
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher>
    with TickerProviderStateMixin {
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
            child: Center(child: Text("Attendances result")),
          )),
      FadeTransition(
          opacity: widgetAnimation,
          child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: MakeAttendance(username: widget.username),
          )),
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
            child: MyCourses(username: widget.username),
          )),
    ];

    widgetController.forward();
    Notificator().setOnDone(() => _restartApp());
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

  Widget _getNavigationDrawer() {
    return Align(
      alignment: Alignment.topLeft,
      child: SlideTransition(
        position: drawerAnimation,
        child: NavigationDrawer(
            options: navigationOptionsTeacher,
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

  Widget _getNavigationDrawerButton() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(top: 35, left: 15),
          height: 35,
          width: 35,
          child: Material(
            color: Colors.transparent,
            elevation: 20,
            child: Container(
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
                  color: _getDrawerButtonColor(_selectedItem),
                ),
              ),
            ),
          ),
        ));
  }

  Color _getDrawerButtonColor(final int _item) {

    switch(_item){
      case 4:
        return Colors.white70;
    }

    return Colors.black;
  }

  void _selection(final int index, final BuildContext context) {
    switch (index) {
      case 2:
        _logoutAction(context);
        break;
      default:
        widgetController.reverse().then((f) {
          widgetController.forward();
          setState(() {
            _isDrawerVisible = false;
            _selectedItem = index;
          });
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widgetController.dispose();
    controllerDrawer.dispose();
  }

  void _restartApp() {
    Notificator().close();
    RestartWidget.restartApp(context);
  }

  void _logoutAction(final BuildContext context) {
    Navigator.of(context).pop();
    Notificator().setOnDone(() {});
    Notificator().close();
  }

  bool _isDrawerVisible = false;
  int _selectedItem = 0;
  List<Widget> widgets;

  AnimationController widgetController;
  AnimationController controllerDrawer;
  Animation<double> widgetAnimation;
  Animation<Offset> drawerAnimation;
}
