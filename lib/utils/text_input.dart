
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {

  TextInput({this.controller, this.name, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
      child: TextFormField(
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
}