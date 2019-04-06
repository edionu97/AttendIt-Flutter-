import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {

  Bottom({this.width, this.height});

  @override
  Widget build(BuildContext context) {

    final double filedPadding = 20;

    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: 30),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: filedPadding),
          child: TextFormField(
            obscureText: true,
            decoration: new InputDecoration(
                labelText: "Password",
                fillColor: Colors.white,
                icon: new Icon(Icons.vpn_key),
                border: InputBorder.none),
            keyboardType: TextInputType.text,
            style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: filedPadding),
            child: TextFormField(
              obscureText: true,
              decoration: new InputDecoration(
                  labelText: "New password",
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: new Icon(Icons.vpn_key)),
              keyboardType: TextInputType.text,
              style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
            )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: filedPadding),
            child: TextFormField(
              obscureText: true,
              decoration: new InputDecoration(
                  labelText: "Confirim password",
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: new Icon(Icons.vpn_key)
              ),
              keyboardType: TextInputType.text,
              style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
            )),
      ],
    ),);
  }

  final double width;
  final double height;
}
