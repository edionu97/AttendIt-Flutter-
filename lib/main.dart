import 'package:attend_it/login_screen/component.dart';
import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }

  Key key = new UniqueKey();
}

class AppScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: LoginScreen());
  }
}

void main() {
  runApp(RestartWidget(
      child: MaterialApp(
    title: "AttendIt",
    home: AppScreen(),
  )));
}
