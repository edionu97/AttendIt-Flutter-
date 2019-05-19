import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {

  Video({@required this.assertImage, @required this.onClickGotIt, @required this.text});

  @override
  _VideoState createState() => _VideoState();

  final String assertImage;
  final String text;
  final Function onClickGotIt;
}

class _VideoState extends State<Video> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(
      begin: Offset(0, 1), end:  Offset(0, 0)
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
    return SlideTransition(
      position: _animation2,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1),
          height: 180,
          width: MediaQuery.of(context).size.width,
          decoration: Decorator.getDialogDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                _firstPart(context),
                _secondPart(context),
                _thirdPart(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstPart(final BuildContext context){
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
        image: DecorationImage(
            fit:BoxFit.fill,
            image: AssetImage(widget.assertImage)
        )
      ),
      width: 100,
      height: 100,
    );
  }

  Widget _secondPart(final BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text(
              widget.text,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
            )
        ],
      ),
    );
  }

  Widget _thirdPart(final BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Material(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: (){
                _animationController.reverse().then((f)=> Navigator.of(context).pop());
              },
              child: Container(
                child: Text(
                  "CANCEL",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12,),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Material(
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: (){
                  widget.onClickGotIt();
                },
                child: Text(
                  "GOT IT",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  AnimationController _animationController;
  Animation<Offset> _animation2;
}
