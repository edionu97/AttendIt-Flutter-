import 'package:flutter/material.dart';

class DialogCustom extends StatefulWidget {
  DialogCustom(
      {this.title = "Error",
      this.textColor = Colors.black,
      this.message = "An error has occurred",
      this.icon = const Icon(Icons.error, size: 30, color: Colors.black)});

  @override
  _DialogCustomState createState() => _DialogCustomState();

  final Icon icon;
  final String title;
  final String message;
  final Color textColor;
}

class _DialogCustomState extends State<DialogCustom>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animation =
        new Tween<double>(begin: 0, end: .9).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context),
    );
  }

  Widget _getWidget(final BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              __getTitle(context),
              __getContent(context),
              __getButtons(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget __getTitle(final BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30)),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: .2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                    fontFamily: "Times New Roman",
                    fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget __getContent(final BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: .2))),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(widget.message,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontFamily: "Times New Roman")),
        ),
      ),
    );
  }

  Widget __getButtons(final BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(bottomRight: const Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
              child: new Text(
                "CLOSE",
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              onPressed: () async {
                await _animationController.reverse();
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  AnimationController _animationController;
  Animation<double> _animation;
}
