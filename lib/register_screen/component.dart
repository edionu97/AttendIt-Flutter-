import 'package:attend_it/utils/form.dart';
import 'package:attend_it/utils/animated_button.dart';
import 'package:attend_it/utils/upper_element.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body : Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UpperElement(name: 'Register', path: 'assets/register.png'),
                  RegisterForm(
                    controllerConfirmPassword: controllerConfirmPassword,
                    controllerPassword: controllerPassword,
                    controllerUsername: controllerUsername,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                          onTap: ()  => _signInPressed(context),
                          child: Text.rich(
                            TextSpan(
                              text: 'Already Having An Account? ',
                              style: TextStyle(fontSize: 17),
                              children: [
                                TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrangeAccent,
                                        fontSize: 17)),
                              ],
                            ),
                          ))),
                  Padding(
                    child: AnimatedButton(name: "Register", action: null),
                    padding: EdgeInsets.only(bottom: 25),
                  )
                ],
              ))
    );
  }

  void _signInPressed(BuildContext context){
    Navigator.pop(context);
  }

  final TextEditingController controllerUsername = new TextEditingController();
  final TextEditingController controllerPassword = new TextEditingController();
  final TextEditingController controllerConfirmPassword =
      new TextEditingController();
}
