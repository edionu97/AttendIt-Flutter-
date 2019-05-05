import 'package:attend_it/users/student/service/enrollment_service.dart';
import 'package:attend_it/users/student/service/models/enrollment.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:attend_it/utils/student_attendance_screen/attendances.dart';
import 'package:flutter/material.dart';

class EnrolledAttendances extends StatefulWidget {
  EnrolledAttendances({@required this.username});

  @override
  _EnrolledAttendancesState createState() => _EnrolledAttendancesState();

  final String username;
}

class _EnrolledAttendancesState extends State<EnrolledAttendances> {
  @override
  void initState() {
    super.initState();
    _getEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: _isLoading
          ? Center(
              child: Loader(),
            )
          : _createView(context, _enrollments),
    ));
  }

  void _getEnrollments() async {
    try {
      List<Enrollment> __enrollments = await EnrollmentService()
          .getEnrollmentsFor(username: widget.username);

      setState(() {
        _isLoading = false;
        this._enrollments = __enrollments;
      });

      __enrollments = await EnrollmentService()
          .completeEnrollments(__enrollments, widget.username);

      setState(() {
        this._enrollments = __enrollments;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Widget _createView(
      final BuildContext context, final List<Enrollment> courses) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(0));

    if (courses.isEmpty) {
      return Center(
        child: Text("No data to be displayed"),
      );
    }
    return Stack(
      children: <Widget>[
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Material(
                borderRadius: radius,
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    image: DecorationImage(
                      image: AssetImage("attendance.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft, child: _buildList(courses)),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildList(final List<Enrollment> courses) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, courses[index]));
  }

  Widget _buildListItem(
      final BuildContext context, final Enrollment enrollment) {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            trailing: Text(
              "Enroll at ${enrollment.date}",
              //course.type,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                enrollment.courseName,
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontFamily: "times new roman"),
              ),
            ),
            leading: _buildListLeading(context, enrollment),
            subtitle: _getSubtitle(enrollment, context),
          ),
        ),
      ),
    );
  }

  Widget _buildListLeading(
      final BuildContext context, final Enrollment course) {
    return Container(
      height: 60,
      width: 60,
      child: Material(
        elevation: 10,
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(
            course.abbreviation,
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

  Widget _getSubtitle(final Enrollment enrollment, final BuildContext context) {
    if (enrollment.atCourse == null ||
        enrollment.atSeminary == null ||
        enrollment.atLaboratory == null) {
      return Container();
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _createBottom(enrollment, "CRS",
              enrolled: enrollment.atCourse, context: context, type: "COURSE"),
          _createBottom(enrollment, "LAB",
              enrolled: enrollment.atLaboratory,
              context: context,
              type: "LABORATORY"),
          _createBottom(enrollment, "SEM",
              enrolled: enrollment.atSeminary,
              context: context,
              type: "SEMINAR"),
        ],
      ),
    );
  }

  void _getAttendances(
      final Enrollment enrollment, final BuildContext cont, final String type) {
    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Attendances(
                            username: widget.username,
                            enrollment: enrollment,
                            type: type),
                        Divider(
                          height: 5,
                        )
                      ])),
            ),
          );
        });
  }

  Widget _createBottom(final Enrollment enrollment, final String text,
      {final BuildContext context, bool enrolled = true, final String type}) {
    return InkWell(
      onTap: enrolled ? () => _getAttendances(enrollment, context, type) : null,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          SizedBox(
            width: 1,
          ),
          Opacity(
              opacity: .8,
              child: enrolled
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 17,
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                      size: 17,
                    ))
        ],
      ),
    );
  }

  List<Enrollment> _enrollments = [];
  bool _isLoading = true;
}
