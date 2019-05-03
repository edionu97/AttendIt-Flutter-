import 'dart:io';
import 'package:attend_it/service/profile_service.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
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
                  image: image,
                )),
            Align(
              alignment: Alignment.topCenter,
              child: Middle(
                startAt: startMiddle,
                height: middleHeight,
                width: middleWidth,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                email: email,
                formKey: formKey,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Bottom(
                height: middleHeight - 120,
                width: middleWidth,
                password: password,
                newPassword: newPassword,
                formState: secondFormKey,
              ),
            ),
            RoundBorderButton(
              buttonIcon: Icons.edit,
              iconColor: Colors.white,
              splashColor: Colors.blueGrey[500],
              onTap: () => this._editPressed(context),
              buttonColor: Colors.blueGrey[400],
            ),]
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    this._getInfo(context);
  }

  Future<void> _choosePictureClicked(final BuildContext context) async {
    GUI.choosePictureLocation(
        context: context,
        afterOpen: (File img) async {

          if (img == null) {
            return;
          }

          setState(() {
            image = new Image.file(img);
            imageFile = img;
          });
        });
  }

  Future<void> _editPressed(BuildContext context) async {

    bool firstFormValidation = formKey.currentState.validate();
    bool secondFormValidation = secondFormKey.currentState.validate();

    if (!firstFormValidation || !secondFormValidation) {
      return;
    }

    // change profile info
    try {
      await this
          ._service
          .createUpdateProfile(widget.username, email.text, firstName.text, lastName.text, phoneNumber.text);
      Future.delayed(
        Duration.zero,
        () => GUI.openDialog(
            context: context,
            message: "Profile updated successfully",
            title: "Success",
            iconData: Icons.check,
            iconColor: Colors.green
        ),
      );
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }

    //upload picture
    if (image != null && imageFile != null) {
      try {
        await _service.uploadImage(widget.username, imageFile);
      }on Exception catch(e){
        Future.delayed(Duration.zero,
                () => GUI.openDialog(context: context, message: e.toString()));
      }
    }

    if (password.text.isEmpty) {
      return;
    }

    //change user password
    try {
      await this._service.changePassword(
          widget.username, password.text, newPassword.text);
      Future.delayed(
          Duration.zero,
          () => GUI.openDialog(
              context: context,
              message: "Password changed successfully",
              title: "Success",
              iconColor: Colors.green,
              iconData: Icons.check
          ));
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Future<void> _getInfo(final BuildContext context) async {
    try {
      dynamic response = await _service.getProfile(widget.username);
      setState(() {
        firstName.text = response['first'];
        lastName.text = response['last'];
        email.text = response['email'];
        phoneNumber.text = response['phone'];
        image = response["image"];
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final TextEditingController newPassword = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>(),
      secondFormKey = new GlobalKey<FormState>();

  final ProfileService _service = new ProfileService();

  Image image;
  File imageFile;

}
