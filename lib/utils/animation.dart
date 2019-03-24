import 'package:attend_it/register_screen/component.dart';
import 'package:flutter/cupertino.dart';

class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute()
      : super(builder: (BuildContext context) => RegisterScreen());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {

      return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: RegisterScreen(),
          )
    );
  }
}
