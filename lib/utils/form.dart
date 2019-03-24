import 'package:attend_it/utils/text_input.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm(
      {this.controllerUsername,
      this.controllerPassword,
      this.controllerConfirmPassword});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFormState();
  }

  final TextEditingController controllerUsername;
  final TextEditingController controllerPassword;
  final TextEditingController controllerConfirmPassword;
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          widget.controllerUsername != null
              ? TextInput(
                  name: "Username",
                  iconData: Icons.person_outline,
                  controller: widget.controllerUsername)
              : null,
          widget.controllerPassword != null
              ? TextInput(
                  name: "Enter password",
                  iconData: Icons.vpn_key,
                  controller: widget.controllerPassword)
              : null,
          widget.controllerConfirmPassword != null
              ? TextInput(
                  name: "Confirm password",
                  iconData: Icons.vpn_key,
                  controller: widget.controllerConfirmPassword)
              : null,
        ].where((element) => element != null).toList(),
      ),
    );
  }
}
