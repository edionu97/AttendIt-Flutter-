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

  final FocusNode focusNodeUsername = new FocusNode();
  final FocusNode focusNodePassword = new FocusNode();
  final FocusNode focusNodeConfirm = new FocusNode();
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
              ? Material(
                  child: TextInput(
                      name: "Username",
                      iconData: Icons.person_outline,
                      controller: widget.controllerUsername,
                      focusNode: widget.focusNodeUsername,
                      fieldSubmitted: () => FocusScope.of(context).requestFocus(widget.focusNodePassword),
                  ))
              : null,
          widget.controllerPassword != null
              ? Material(
                  child: TextInput(
                      name: "Enter password",
                      iconData: Icons.vpn_key,
                      isHidden: true,
                      controller: widget.controllerPassword,
                      focusNode: widget.focusNodePassword,
                      fieldSubmitted: () => FocusScope.of(context).requestFocus(widget.focusNodeConfirm)))
              : null,
          widget.controllerConfirmPassword != null
              ? Material(
                  child: TextInput(
                      name: "Confirm password",
                      iconData: Icons.vpn_key,
                      isHidden: true,
                      controller: widget.controllerConfirmPassword,
                      action: TextInputAction.done,
                      focusNode: widget.focusNodeConfirm))
              : null,
        ].where((element) => element != null).toList(),
      ),
    );
  }
}
