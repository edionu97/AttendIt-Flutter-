import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));

    _animationRadiusIn = new Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.5, 1, curve: Curves.elasticIn)));

    _animationRadiusOut = new Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 0.5, curve: Curves.elasticOut)));

    _animationController.addListener(() {
      setState(() {
        if (_animationController.value >= 0.5 &&
            _animationController.value <= 1.0) {
          _radius = _animationRadiusIn.value * _initialRadius;
          return;
        }

        if (_animationController.value >= 0 &&
            _animationController.value <= .5) {
          _radius = _animationRadiusOut.value * _initialRadius;
        }
      });
    });

    _animationRotation = new Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _dotRadius = 5.5;
    final double _radianStep = 4;

    return Container(
      width: 150,
      height: 150,
      child: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: Dot(
                radius: 10,
                color: Colors.blueGrey[400],
              ),
            ),
            RotationTransition(
              turns: _animationRotation,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(cos(pi / _radianStep) * _radius,
                        sin(pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(2 * pi / _radianStep) * _radius,
                        sin(2 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(3 * pi / _radianStep) * _radius,
                        sin(3 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(4 * pi / _radianStep) * _radius,
                        sin(4 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(5 * pi / _radianStep) * _radius,
                        sin(5 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(6 * pi / _radianStep) * _radius,
                        sin(6 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(7 * pi / _radianStep) * _radius,
                        sin(7 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  ),
                  Transform.translate(
                    offset: Offset(cos(8 * pi / _radianStep) * _radius,
                        sin(8 * pi / _radianStep) * _radius),
                    child: Dot(radius: _dotRadius, color: Colors.blueGrey[600]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimationController _animationController;
  Animation<double> _animationRotation;
  Animation<double> _animationRadiusIn;
  Animation<double> _animationRadiusOut;

  final double _initialRadius = 30;

  double _radius = 0;
}

class Dot extends StatelessWidget {
  Dot({this.color, this.radius, this.hasImage = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: this.radius,
          height: this.radius,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              image: hasImage
                  ? DecorationImage(image: AssetImage("user.png"))
                  : null)),
    );
  }

  final double radius;
  final Color color;
  final bool hasImage;
}
