import 'package:flutter/material.dart';

class RoundBorderButton extends StatelessWidget {

  RoundBorderButton(
      {@required this.onTap,
        @required this.splashColor,
        @required this.buttonColor,
        @required this.iconColor,
        @required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.only(right: 20, bottom: 18),
        child: Material(
          color: buttonColor,
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Container(
            child: Container(
              child: InkWell(
                splashColor: splashColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                onTap: () => onTap(),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    buttonIcon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final Function onTap;
  final Color splashColor;
  final Color buttonColor;
  final Color iconColor;
  final IconData buttonIcon;
}
