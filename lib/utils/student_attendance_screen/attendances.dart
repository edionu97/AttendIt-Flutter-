import 'package:attend_it/users/student/service/attendance_service.dart';
import 'package:attend_it/users/common/models/attendance.dart';
import 'package:attend_it/users/common/models/enrollment.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class Attendances extends StatefulWidget {
  Attendances({this.username, this.enrollment, this.type});

  @override
  _AttendancesState createState() => _AttendancesState();

  void hide(){
    if (list.isEmpty) {
      return;
    }

    final _AttendancesState _attendancesState = list[0];
    _attendancesState.hide();
  }

  final String username;
  final Enrollment enrollment;
  final String type;

  final List<_AttendancesState> list = [];
}

class _AttendancesState extends State<Attendances>
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

    _getAttendances();
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
                  height: MediaQuery.of(context).size.height / 1.75,
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
            : _createView(context, _attendance));
  }

  Widget _createView(
      final BuildContext context, final List<Attendance> attendances) {

    if(attendances.isEmpty){
      return Center(
        child: Text("No data to be displayed")
      );
    }

    final BorderRadius radius = BorderRadius.only(
        topLeft: Radius.circular(25), topRight: Radius.circular(25));

    return Stack(
      children: <Widget>[
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
              child: Material(
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: radius),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your attendances at ${widget.enrollment.abbreviation}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.blueGrey,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildList(attendances)),
            ),
            Divider(height: 5, color: Colors.blueGrey),
            Container(
              height: 25,
              child: Center(
                  child: Text(
                "You have ${_attendance.length} attendances at this ${widget.type} ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              )),
            )
          ],
        )),
      ],
    );
  }

  Widget _buildList(final List<Attendance> attendances) {
    return ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, attendances[index]));
  }

  Widget _buildListItem(
      final BuildContext context, final Attendance attendance) {
    return Card(
      elevation: 5,
      child: Container(
        child: ListTile(
          dense: true,
          trailing: Text(
            "${widget.type}",
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.enrollment.courseName,
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontFamily: "times new roman"),
            ),
          ),
          leading: _buildListLeading(context, attendance),
          subtitle: _getSubtitle(attendance, context),
        ),
      ),
    );
  }

  Widget _buildListLeading(
      final BuildContext context, final Attendance attendance) {
    return Container(
      height: 55,
      width: 55,
      margin: EdgeInsets.only(right: 5),
      child: Material(
        elevation: 10,
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            widget.enrollment.abbreviation,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
      ),
    );
  }

  Widget _getSubtitle(final Attendance attendance, BuildContext context) {
    return Text(
        "Date and hour ${attendance.attendanceDate} ${attendance.attendanceTime}");
  }

  void _getAttendances() async {
    try {
      final List<Attendance> __attendance = await AttendanceService()
          .getAttendancesForAt(widget.username, widget.enrollment.teacherName,
              widget.enrollment.courseName, widget.type);

      if (!this.mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        this._attendance = __attendance;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  void hide(){
    _animationController
        .reverse()
        .then((_) => Navigator.of(context).pop());
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  bool _isLoading = true;
  List<Attendance> _attendance = [];
}
