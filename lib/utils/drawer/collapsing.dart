import 'package:flutter/material.dart';

class CollapsingListTitle extends StatefulWidget {
  CollapsingListTitle(
      {this.title,
      this.icon,
      this.animationController,
      this.minWidth = 70,
      this.maxWidth = 250});

  @override
  _CollapsingListTitleState createState() => _CollapsingListTitleState();

  final String title;
  final IconData icon;
  final double minWidth, maxWidth;
  final AnimationController animationController;
}

class _CollapsingListTitleState extends State<CollapsingListTitle> {

  @override
  void initState() {
    super.initState();
    _widthAnimation =
        Tween<double>(begin: widget.minWidth, end:  widget.maxWidth)
            .animate(widget.animationController);
    _sizedBoxAnimation =
        Tween<double>(begin: 0, end: 10).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {

    final Color iconColor = Colors.white70;
    final double iconSize = 38.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: _widthAnimation.value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            widget.icon,
            color: iconColor,
            size: iconSize,
          ),
          SizedBox(width: _sizedBoxAnimation.value),
          _widthAnimation.value >= widget.maxWidth
              ? Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 18,
                      fontFamily: "times new roman"))
              : Container()
        ],
      ),
    );
  }

  Animation<double> _widthAnimation;
  Animation<double> _sizedBoxAnimation;
}
