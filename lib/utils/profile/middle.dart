import 'package:flutter/material.dart';

class Middle extends StatefulWidget{

  Middle({@required this.height, @required this.width, @required this.startAt});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Middle();
  }

  final double height;
  final double width;
  final double startAt;
}

class _Middle extends State<Middle> {

  @override
  Widget build(BuildContext context) {
    final double filedPadding = 20;

    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(top: widget.startAt),
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
              validator: (val){
                if(val.isEmpty){
                  return "This field should not be empty!";
                }
                return null;
              },
              decoration: new InputDecoration(
                  labelText: "First name",
                  fillColor: Colors.white,
                  icon: new Icon(Icons.person_outline),
                  border: InputBorder.none),
              keyboardType: TextInputType.text,
              style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: filedPadding),
              child: TextFormField(
                validator: (val) {
                  if(val.isEmpty){
                    return "This field should not be empty!";
                  }
                  return null;
                },
                decoration: new InputDecoration(
                    labelText: "Last name",
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    icon: new Icon(Icons.person_outline)),
                keyboardType: TextInputType.text,
                style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: filedPadding),
              child: TextFormField(
                validator: (val){
                  return null;
                },
                decoration: new InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    icon: new Icon(Icons.email)
                ),
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: filedPadding),
            child: TextFormField(
              decoration: new InputDecoration(
                  labelText: "Phone number",
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: new Icon(Icons.phone)
              ),
              keyboardType: TextInputType.number,
              style: new TextStyle(fontFamily: "Poppins", fontSize: 18),
            ),
          )
        ],
      ),
    );
  }


}
