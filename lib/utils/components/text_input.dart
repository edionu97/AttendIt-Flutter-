import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {this.controller,
      this.name,
      this.iconData,
      this.isHidden = false,
      this.action = TextInputAction.next,
      this.focusNode,
      this.fieldSubmitted,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
      child: TextFormField(
        validator: (value) {
          if(validator != null){
            return validator(value);
          }
        },
        textInputAction: action,
        obscureText: isHidden,
        focusNode: focusNode,
        onFieldSubmitted: (v) => fieldSubmitted != null ? fieldSubmitted() : (){},
        decoration: InputDecoration(
          hintText: this.name,
          icon: Icon(
            iconData,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
        controller: controller,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
    );
  }

  final TextEditingController controller;
  final String name;
  final IconData iconData;
  final bool isHidden;
  final TextInputAction action;
  final FocusNode focusNode;
  final Function fieldSubmitted;
  final Function validator;
}
