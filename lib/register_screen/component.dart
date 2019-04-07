import 'package:attend_it/service/login_service.dart';
import 'package:attend_it/utils/components/form.dart';
import 'package:attend_it/utils/components/animated_button.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/components/upper_element.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _RegisterScreen();
  }
}

class _RegisterScreen extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    UpperElement(name: 'Register', path: 'assets/register.png'),
                    RegisterForm(
                      controllerConfirmPassword: controllerConfirmPassword,
                      controllerPassword: controllerPassword,
                      controllerUsername: controllerUsername,
                      formKey: _formKey,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                            onTap: () => _signInPressed(context),
                            child: Text.rich(
                              TextSpan(
                                text: 'Already Having An Account? ',
                                style: TextStyle(fontSize: 17),
                                children: [
                                  TextSpan(
                                      text: 'Sign In',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[700],
                                          fontSize: 17)),
                                ],
                              ),
                            ))),
                    Padding(
                      child: AnimatedButton(
                          name: "Register",
                          action: () => _registerPressed(context)),
                      padding: EdgeInsets.only(bottom: 25),
                    )
                  ],
                ))));
  }

  void _signInPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _registerPressed(BuildContext context) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }
      dynamic response = await _loginService.createAccount(
          controllerUsername.text, controllerPassword.text);
      GUI.openDialog(
          context: context, message: response["msg"], title: "Success");
    } on Exception catch (e) {
      final String message = e.toString().split(":")[1];
      GUI.openDialog(context: context, message: message);
    }
  }

  @override
  void dispose(){
    super.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerUsername.dispose();
  }

  final TextEditingController controllerPassword = new TextEditingController();
  final TextEditingController controllerConfirmPassword =
      new TextEditingController();
  final TextEditingController controllerUsername = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final LoginService _loginService = new LoginService();
}
