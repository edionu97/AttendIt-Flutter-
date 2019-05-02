import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:flutter/material.dart';

class Enroll extends StatefulWidget {
  @override
  _EnrollState createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(
        begin: Offset(1, 0), end:  Offset(0, 0)
    ).animate(_animationController);

    _animation1 = new Tween(
        begin: 0.0, end: 1.0
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context, widget),
    );

  }

  Widget _getWidget(final BuildContext context, final Widget wid){
    return ScaleTransition(
      scale: _animation1,
      child: SlideTransition(
        position: _animation2,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: Decorator.getDialogDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("ana are mere"),
                Text("ana are mere")
//              _firstPart(context),
//              _secondPart(context),
//              _thirdPart(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;
}
