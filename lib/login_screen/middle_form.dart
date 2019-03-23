import 'package:flutter/material.dart';

class MiddleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
        child: Column(children: [
          Container(
            height: 50,
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Username",
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
          ),
          SizedBox(height: 50),
          Container(
            height: 50,
            padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(
                  Icons.vpn_key,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
          )
        ],
      ),
    );
  }
}
