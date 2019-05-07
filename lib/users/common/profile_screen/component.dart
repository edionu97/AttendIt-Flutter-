import 'dart:io';
import 'package:attend_it/users/student/service/profile_service.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
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
        child: _isLoading
            ? Center(
                child: Loader(),
              )
            : Stack(
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
                    _isButtonEnabled
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundBorderButton(
                              height: 50,
                              weight: 50,
                              iconSize: 25,
                              buttonIcon: Icons.check,
                              iconColor: Colors.white,
                              splashColor: Colors.blueGrey[600],
                              onTap: () => this._editPressed(context),
                              buttonColor: Colors.blueGrey,
                            ),
                          )
                        : Container(),
                  ]),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    this._getInfo(context);
  }

  void _createTextFieldListener(
      final TextEditingController _controller, final String oldValueKey) {
    final String text = _controller.text;

    if (_oldFieldValues[oldValueKey] == text) {
      setState(() {
        _isButtonEnabled = false;
      });
      return;
    }

    setState(() {
      _isButtonEnabled = true;
    });
  }

  Future<void> _choosePictureClicked(final BuildContext context) async {
    GUI.choosePictureLocation(
        context: context,
        afterOpen: (File img) async {
          if (img == null) {
            return;
          }
          setState(() {
            _isButtonEnabled = true;
          });
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
      await this._service.createUpdateProfile(widget.username, email.text,
          firstName.text, lastName.text, phoneNumber.text);
      Future.delayed(
        Duration.zero,
        () => GUI.openDialog(
            context: context,
            message: "Profile updated successfully",
            title: "Success",
            iconData: Icons.check,
            iconColor: Colors.green),
      );
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }

    //upload picture
    if (image != null && imageFile != null) {
      try {
        await _service.uploadImage(widget.username, imageFile);
      } on Exception catch (e) {
        Future.delayed(Duration.zero,
            () => GUI.openDialog(context: context, message: e.toString()));
      }
    }

    if (password.text.isEmpty) {
      return;
    }

    //change user password
    try {
      await this
          ._service
          .changePassword(widget.username, password.text, newPassword.text);
      Future.delayed(
          Duration.zero,
          () => GUI.openDialog(
              context: context,
              message: "Password changed successfully",
              title: "Success",
              iconColor: Colors.green,
              iconData: Icons.check));
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Future<void> _getInfo(final BuildContext context) async {
    try {
      dynamic response = await _service.getProfile(widget.username);
      setState(() {
        _isLoading = false;
        firstName.text = response['first'];
        lastName.text = response['last'];
        email.text = response['email'];
        phoneNumber.text = response['phone'];
        image = response["image"];
        _populateTextFields(response);
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  void _populateTextFields(final dynamic response){

    _oldFieldValues.putIfAbsent("firstName", () => response['first']);
    _oldFieldValues.putIfAbsent("lastName", () => response['last']);
    _oldFieldValues.putIfAbsent("email", () => response['email']);
    _oldFieldValues.putIfAbsent("phone", () => response['phone']);
    _oldFieldValues.putIfAbsent("password", ()=> password.text);

    firstName
        .addListener(() => _createTextFieldListener(firstName, "firstName"));

    lastName.addListener(() => _createTextFieldListener(lastName, "lastName"));

    email.addListener(() => _createTextFieldListener(email, "email"));

    phoneNumber.addListener(() => _createTextFieldListener(phoneNumber, "phone"));

    password.addListener(() => _createTextFieldListener(password, "password"));
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  final TextEditingController newPassword = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>(),
      secondFormKey = new GlobalKey<FormState>();

  final Map<String, String> _oldFieldValues = {};
  final ProfileService _service = new ProfileService();

  Image image;
  File imageFile;
  bool _isLoading = true;
  bool _isButtonEnabled = false;
}
