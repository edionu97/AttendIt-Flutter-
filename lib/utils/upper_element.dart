import 'package:attend_it/utils/decoration_form.dart';
import 'package:flutter/material.dart';

class UpperElement extends StatelessWidget {
  UpperElement({this.name, this.path});

  @override
  Widget build(BuildContext context) {
    print(path);
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            decoration: Decorator.getDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 26),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Image.asset(path, height: 70, width: 70),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        padding: const EdgeInsets.only(bottom: 15, right: 20),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                              color: Colors.white),
                        ))),
              ],
            )));
  }

  final String path;
  final String name;
}
