import 'package:attend_it/service/profile_service.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/profile/bottom.dart';
import 'package:attend_it/utils/profile/header_part.dart';
import 'package:attend_it/utils/profile/middle.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({this.username});

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }

  final String username;

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final TextEditingController newPassword = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>(),
      secondFormKey = new GlobalKey<FormState>();
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
                phoneNumber: widget.phoneNumber,
                email: widget.email,
                formKey: widget.formKey,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Bottom(
                height: middleHeight - 120,
                width: middleWidth,
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
                  margin: EdgeInsets.only(bottom: 18, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            this._editPressed(context);
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    this._getInfo(context);
  }

  void _choosePictureClicked(final BuildContext context) {}

  Future<void> _editPressed(BuildContext context) async {
    bool firstFormValidation = widget.formKey.currentState.validate();
    bool secondFormValidation = widget.secondFormKey.currentState.validate();

    if (!firstFormValidation || !secondFormValidation) {
      return;
    }

    final String username = widget.username;
    final String email = widget.email.text;
    final String firstName = widget.firstName.text;
    final String lastName = widget.lastName.text;
    final String phone = widget.phoneNumber.text;

    // change profile info
    try {
      await this
          ._service
          .createUpdateProfile(username, email, firstName, lastName, phone);
      Future.delayed(
          Duration.zero,
          () => GUI.openDialog(
              context: context, message: "Profile updated successfully", title: "Success"),);
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }


    if(widget.password.text.isEmpty){
      return;
    }

    //change user password
    try{
      await this._service.changePassword(username, widget.password.text, widget.newPassword.text);
      Future.delayed(
          Duration.zero,
              () => GUI.openDialog(
              context: context, message: "Password changed successfully", title: "Success"));
    }on Exception catch(e){
      Future.delayed(Duration.zero,
              () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Future<void> _getInfo(final BuildContext context) async {
    try {
      dynamic response = await _service.getProfile(widget.username);
      setState(() {
        widget.firstName.text = response['first'];
        widget.lastName.text = response['last'];
        widget.email.text = response['email'];
        widget.phoneNumber.text = response['phone'];
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  ProfileService _service = new ProfileService();
}
