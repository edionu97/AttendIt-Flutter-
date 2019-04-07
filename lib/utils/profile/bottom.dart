import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  Bottom(
      {this.width,
      this.height,
      this.password,
      this.newPassword,
      this.formState});

  @override
  State<StatefulWidget> createState() {
    return _Bottom();
  }

  final double width;
  final double height;

  final TextEditingController password, newPassword;
  final GlobalKey<FormState> formState;
}

class _Bottom extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    final double filedPadding = 20;

    return Form(
        key: widget.formState,
        child: Container(
          height: widget.height,
          width: widget.width,
          margin: EdgeInsets.only(bottom: 15),
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: filedPadding),
                child: TextFormField(
                  controller: widget.password,
                  obscureText: true,
                  validator: (val) {
                    if (widget.newPassword.text.isNotEmpty && val.isEmpty) {
                      return "You must enter the current password";
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Password",
                      fillColor: Colors.white,
                      icon: new Icon(Icons.vpn_key),
                      border: InputBorder.none),
                  keyboardType: TextInputType.text,
                  style: new TextStyle(fontFamily: "Poppins", fontSize: 16),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: filedPadding),
                  child: TextFormField(
                    controller: widget.newPassword,
                    validator: (val){
                      if(val.isEmpty && widget.password.text.isNotEmpty){
                        return "You must enter a value";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: "New password",
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        icon: new Icon(Icons.vpn_key)),
                    keyboardType: TextInputType.text,
                    style: new TextStyle(fontFamily: "Poppins", fontSize: 16),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: filedPadding),
                  child: TextFormField(
                    obscureText: true,
                    validator: (val) {

                      if(widget.password.text.isEmpty){
                        return null;
                      }

                      if (widget.newPassword.text.isEmpty) {
                        return null;
                      }

                      if (widget.newPassword.text != val) {
                        return "Passwords are not equal";
                      }

                      return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Confirim password",
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        icon: new Icon(Icons.vpn_key)),
                    keyboardType: TextInputType.text,
                    style: new TextStyle(fontFamily: "Poppins", fontSize: 16),
                  )),
            ],
          ),
        ));
  }
}
