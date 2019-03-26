
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GUI{

  static Dialog createDialog({@required BuildContext context, String message, double pageFraction = 8.5}){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0)
      ),
      //: Colors.orange[600]
        backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / pageFraction,
        decoration: Decorator.getDialogDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(15.0),
              child: Align(alignment: Alignment.center, child :Text('Error', style: TextStyle(color: Colors.black, fontSize: 20)),),
            ),
          ],
        ),
      )
    );
  }

  static void openDialog({@required BuildContext context, String message, String title="Error"}){

    showCupertinoDialog(
          context: context,
          builder: (BuildContext builder) {
            return AlertDialog(
                title: new Text(title),
                content: new Text(message),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          }
        );
  }

}