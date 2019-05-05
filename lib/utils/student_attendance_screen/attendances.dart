import 'package:attend_it/users/student/service/models/enrollment.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class Attendances extends StatefulWidget {
  Attendances({this.username, this.enrollment, this.type});

  @override
  _AttendancesState createState() => _AttendancesState();

  final String username;
  final Enrollment enrollment;
  final String type;
}

class _AttendancesState extends State<Attendances>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

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
                  height: 300,
                  width: MediaQuery.of(context).size.width,
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
    return Container();
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  bool _isLoading = true;
}
