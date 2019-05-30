import 'package:attend_it/users/teacher/models/history_info.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class AttendanceInfo extends StatefulWidget {
  AttendanceInfo({this.historyInfo, this.username});

  @override
  _AttendanceInfoState createState() => _AttendanceInfoState();

  void hide() {
    if (list.length == 0) {
      return;
    }

    final _AttendanceInfoState _attendanceInfoState = list[0];
    _attendanceInfoState.hide();
  }

  final HistoryInfo historyInfo;
  final String username;
  final List<_AttendanceInfoState> list = [];
}

class _AttendanceInfoState extends State<AttendanceInfo>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.list.add(this);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation2 = new Tween(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(_animationController);

    _animation1 = new Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context, widget),
    );
  }

  Widget _getWidget(final BuildContext context, final Widget wid) {
    return GestureDetector(
      onDoubleTap: () => {
            _animationController
                .reverse()
                .then((_) => Navigator.of(context).pop())
          },
      child: FadeTransition(
        opacity: _animation1,
        child: ScaleTransition(
          scale: _animation1,
          child: SlideTransition(
            position: _animation2,
            child: Opacity(
              opacity: 0.94,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  height: MediaQuery.of(context).size.height / 2,
                  width: 300,
                  decoration: Decorator.getDialogDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _firstPart(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstPart(final BuildContext context) {
    return Expanded(
        child: _isLoading
            ? Center(
                child: Loader(),
              )
            : _createView(context));
  }

  Widget _createView(final BuildContext context) {
    
    final BorderRadius borderRadius = new BorderRadius.all(
      Radius.circular(30),
    );
    
    return Column(
      children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.historyInfo.attendanceImage.image,
                fit: BoxFit.fill
              ),
              borderRadius: borderRadius
            ),
          )
      ],
    );
  }

  void hide() {
    _animationController.reverse().then((_) => Navigator.of(context).pop());
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  bool _isLoading = false;
}