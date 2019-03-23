import 'package:flutter/material.dart';

class UpperElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(children: [
            Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset("assets/login.png", height: 66, width: 66),
                  height: MediaQuery.of(context).size.height / 2.5
                )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(bottom: 15, right: 20),
                child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal ,
                        fontSize: 20,
                        color: Colors.white
                    ),
                ),
              ),
            )
          ]),
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1 , 0.5, 0.7, 0.9],
              colors: [
                Colors.orange[900],
                Colors.orange[800],
                Colors.orange[700],
                Colors.orange[600],
              ],
            ),
            borderRadius:
                new BorderRadius.only(bottomLeft: const Radius.circular(150)),
          ),
        ));
  }
}
