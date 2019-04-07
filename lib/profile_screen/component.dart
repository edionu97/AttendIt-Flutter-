import 'package:attend_it/utils/profile/bottom.dart';
import 'package:attend_it/utils/profile/header_part.dart';
import 'package:attend_it/utils/profile/middle.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final TextEditingController newPassword = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>(), secondFormKey = new GlobalKey<FormState>();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height / 3.5;

    final double startMiddle = headerHeight - 30;
    final double middleWidth = MediaQuery.of(context).size.width - 50;
    final double middleHeight = MediaQuery.of(context).size.height / 2.35;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Header(
                  height: headerHeight,
                  width: MediaQuery.of(context).size.width,
                  onPress: () => this._choosePictureClicked(context),
                )),
            Align(
              alignment: Alignment.topCenter,
              child: Middle(
                startAt: startMiddle,
                height: middleHeight,
                width: middleWidth,
                firstName: widget.firstName,
                lastName: widget.lastName,
                phoneNumber:widget.phoneNumber,
                email: widget.email,
                formKey: widget.formKey,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Bottom(
                  height: middleHeight - 120, width: middleWidth,
                  password: widget.password,
                  newPassword: widget.newPassword,
                  formState: widget.secondFormKey,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.blueGrey[500],
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.blueGrey[400],
                          blurRadius: 2,
                        )
                      ]),
                  height: 65,
                  width: 65,
                  margin: EdgeInsets.only(bottom:18 , right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            this._editPressed(context);
                          },
                          child: Icon(Icons.edit, color: Colors.white,)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  void _choosePictureClicked(final BuildContext context){

  }

  void _editPressed(BuildContext context) {

    bool firstFormValidation = widget.formKey.currentState.validate();
    bool secondFormValidation = widget.secondFormKey.currentState.validate();

    if(!firstFormValidation || !secondFormValidation){
      return;
    }


  }
}
