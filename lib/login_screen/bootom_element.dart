import 'package:flutter/material.dart';

class BottomElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 80),
      Center(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onTap: (){
                  print('Register pressed');
                },
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
      ),
      SizedBox(height: 20),
      Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.only(left: 16, right: 16),
        height: 50,
        child: RaisedButton(
          onPressed: () =>
          {
          print('ana are mere')
          },
          disabledColor: Colors.orange[700],
          color: Colors.orange[700],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: Text(
            "LOGIN",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
      )
    ]);
  }
}
