import 'package:attend_it/register_screen/component.dart';
import 'package:attend_it/utils/animated_button.dart';
import 'package:attend_it/utils/animation.dart';
import 'package:attend_it/utils/form.dart';
import 'package:attend_it/utils/upper_element.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        UpperElement(name: 'Login', path: 'assets/login.png'),
        RegisterForm(
          controllerPassword: controllerPassword,
          controllerUsername: controllerUsername,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onTap: () => _registerPressed(context),
                child: Text.rich(
                  TextSpan(
                    text: 'Not Having An Account? ',
                    style: TextStyle(fontSize: 17),
                    children: [
                      TextSpan(
                          text: 'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,
                              fontSize: 17)),
                    ],
                  ),
                ))),
        Padding(
          child: AnimatedButton(name: "Sign In", action: null),
          padding: EdgeInsets.only(bottom: 25),
        )
      ],
    )));
  }

  void _registerPressed(BuildContext context) {
    Navigator.of(context).push(SecondPageRoute());
  }

  final TextEditingController controllerUsername = new TextEditingController();
  final TextEditingController controllerPassword = new TextEditingController();
}
