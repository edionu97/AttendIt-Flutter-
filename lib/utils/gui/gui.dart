import 'dart:io';

import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:attend_it/utils/gui/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GUI {
  static Dialog createDialog(
      {@required BuildContext context,
      String message,
      double pageFraction = 8.5}) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        //: Colors.orange[600]
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height / pageFraction,
          decoration: Decorator.getDialogDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Error',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
            ],
          ),
        ));
  }

  static void openDialog(
      {@required BuildContext context,
      String message,
      String title = "Error",
      IconData iconData = Icons.error,
      Color iconColor = Colors.black}) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              // container to set color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DialogCustom(
                      message: message,
                      title: title,
                      icon: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    )
                  ]));
        });
  }

  static void choosePictureLocation(
      {@required BuildContext context, Function afterOpen}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
              title: new Text("Question"),
              content: new Text("Select picture location"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                    child: new Text("Open galery"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: Constants.PROFILE_PICTURE_HEIGHT,
                          maxWidth: Constants.PROFILE_PICTURE_WIDTH);
                      afterOpen(image);
                    }),
                new FlatButton(
                    child: new Text("Open camera"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          maxHeight: Constants.PROFILE_PICTURE_HEIGHT,
                          maxWidth: Constants.PROFILE_PICTURE_WIDTH);
                      afterOpen(image);
                    })
              ]);
        });
  }

  static void chooseCamera(
      {@required BuildContext context, Function afterOpen}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext builder) {
          return Material(
            borderRadius: const BorderRadius.all(const Radius.circular(30)),
            child: AlertDialog(
                title: new Text("Question"),
                content: new Text("Choose video camera"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                      child: new Text("Frontal camera"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        afterOpen();
                      }),
                  new FlatButton(
                      child: new Text("Back camera"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        afterOpen();
                      })
                ]),
          );
        });
  }

}
