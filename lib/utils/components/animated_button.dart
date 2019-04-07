import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  AnimatedButton({this.name = "", @required this.action});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedButtonState();
  }

  final String name;
  final Function action;
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _buttonSqueezeAnimation = Tween(
      begin: 380,
      end: 70.0,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.0, 0.150)));

    _buttonSqueezeAnimation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              _buttonLoginPressed();
            },
            child: Container(
                width: _buttonSqueezeAnimation.value.toDouble(),
                height: 50,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[500],
                    borderRadius:
                        BorderRadius.all(const Radius.circular(30.0))),
                child: _buttonSqueezeAnimation.value.toDouble() > 75
                    ? Text(widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ))
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ))));
  }

  void _buttonLoginPressed() {
    _playAnimation();
  }

  Future<Null> _playAnimation() async {
    try {
      await _animationController.forward();
      await _animationController.reverse();
      if(widget.action == null){
        return;
      }
      widget.action();
    } on TickerCanceled catch (e) {
      print("Play animation " + e.toString());
    }
  }

  Animation<num> _buttonSqueezeAnimation;
  AnimationController _animationController;
}
