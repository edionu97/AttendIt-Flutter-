import 'package:attend_it/main.dart';
import 'package:attend_it/users/admin/home_screen/component.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/student/home_screen/home_screen.dart';
import 'package:attend_it/users/common/service/login_service.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class RoleChooser extends StatefulWidget {
  RoleChooser({@required this.username});

  @override
  _RoleChooserState createState() => _RoleChooserState();

  final String username;
}

class _RoleChooserState extends State<RoleChooser> {
  @override
  void initState() {
    super.initState();
    _screens = {
      "ADMIN": HomeScreenAdmin(),
      "STUDENT": HomeScreen(
        username: widget.username,
      ),
      "TEACHER": HomeScreen(username: widget.username),
      "OPENED": Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Loader(),
            Text(
              "Gathering account information...",
              style: TextStyle(fontSize: 18),
            )
          ])),
      "UNDEFINED": Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Loader(),
            Text(
              "Waiting for account confirmation...",
              style: TextStyle(fontSize: 18),
            )
          ]))
    };
    _getScreen();
    Notificator().setOnDone(() => _restartApp());
    Notificator().addObserver(_notified);
  }

  @override
  void dispose() {
    Notificator().removeObserver(_notified);
    super.dispose();
  }

  void _getScreen() async {
    try {
      final dynamic response =
          await LoginService().getUserDetails(widget.username);
      setState(() {
        _screenName = response["role"];
      });

      if (response["role"] != "UNDEFINED") {
        return;
      }

      Notificator().sendOnlyTo([
        Constants.ADMIN
      ], {
        "type": NotificationType.NEW_REGISTRATION.toString(),
        "data": {"usern": widget.username}
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () {
              Notificator().setOnDone(() {});
              Notificator().close();
              Navigator.of(context).pop();
            },
            child: _screens[_screenName]));
  }

  void _notified(dynamic notification) {
    final NotificationType type =
        getNotificationTypeFromString(notification["type"]);

    print(notification);

    if (type == NotificationType.ACCOUNT_CONFIRMED) {
      final String userRole = notification["data"]["role"];
      setState(() {
        _screenName = userRole;
      });
    }
  }

  void _restartApp() {
    Notificator().close();
    RestartWidget.restartApp(context);
  }

  Widget screen;
  String _screenName = "OPENED";
  Map<String, Widget> _screens;
}
