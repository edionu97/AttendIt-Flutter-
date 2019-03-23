import 'package:attend_it/login_screen/bootom_element.dart';
import 'package:attend_it/login_screen/middle_form.dart';
import 'package:attend_it/login_screen/upper_element.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          UpperElement(),
          MiddleForm(),
          BottomElement()
        ])));
  }
}
