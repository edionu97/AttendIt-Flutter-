import 'package:attend_it/home_screen/home_screen.dart';
import 'package:attend_it/register_screen/component.dart';
import 'package:attend_it/service/login_service.dart';
import 'package:attend_it/utils/components/animated_button.dart';
import 'package:attend_it/utils/components/animation.dart';
import 'package:attend_it/utils/components/form.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/components/upper_element.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
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
                      child: AnimatedButton(
                          name: "Sign In",
                          action: () => _loginPressed(context)),
                      padding: EdgeInsets.only(bottom: 25),
                    )
                  ],
                ))));
  }

  void _registerPressed(BuildContext context) {
    Navigator.of(context).push(SecondPageRoute(toPage: () => RegisterScreen()));
  }

  void _loginPressed(BuildContext context) async {
    try {
      await _loginService.login(
          controllerUsername.text, controllerPassword.text);
      Navigator.of(context).push(SecondPageRoute(toPage: () => HomeScreen()));
    } on Exception catch (e) {
      final String message = e.toString().split(":")[1];
      GUI.openDialog(context: context, message: message);
    }
  }

  @override
  void dispose(){
    super.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
  }

  final TextEditingController controllerUsername = new TextEditingController();
  final TextEditingController controllerPassword = new TextEditingController();
  final LoginService _loginService = new LoginService();
}
