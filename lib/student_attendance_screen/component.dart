import 'package:attend_it/service/attendance_service.dart';
import 'package:attend_it/service/models/course.dart';
import 'package:attend_it/service/models/profile.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:attend_it/utils/student_attendance_screen/enroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StudentAttendanceScreen extends StatefulWidget {
  StudentAttendanceScreen({@required this.username, @required this.function});

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();

  final String username;
  final Function function;
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _getAllCourses();
  }

  void _getAllCourses() async {
    try {
      final List<Course> __courses =
          await AttendanceService().getAllAvailableCourses();

      setState(() {
        this._courses = __courses;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: _courses.isEmpty
                ? Center(child: Loader())
                : _createView(context, _courses)));
  }

  void _openInfoDialog(final BuildContext cont, final Course course) {
    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              //onTap: () => Navigator.of(context).pop(),
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Enroll(
                          course: course,
                          username: widget.username,
                        ),
                        Divider(
                          height: 5,
                        )
                      ])),
            ),
          );
        });
  }

  Widget _createView(final BuildContext context, final List<Course> courses) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(0));

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
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    image: DecorationImage(
                      image: AssetImage("course.jpg"),
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
        RoundBorderButton(
          onTap: widget.function,
          splashColor: Colors.blueAccent,
          buttonColor: Colors.blue,
          iconColor: Colors.white,
          buttonIcon: Icons.supervisor_account,
        )
      ],
    );
  }

  Widget _buildList(final List<Course> courses) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, courses[index]));
  }

  Widget _buildListItem(final BuildContext context, final Course course) {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: _tileHeight,
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            trailing: Text(
              course.type,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            title: Text(
              course.name,
              style: TextStyle(
                  fontWeight: FontWeight.w300, fontFamily: "times new roman"),
            ),
            leading: _buildListLeading(context, course),
            subtitle: _getSubtitle(course),
          ),
        ),
      ),
    );
  }

  Widget _buildListLeading(final BuildContext context, final Course course) {
    return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: () => _openInfoDialog(context, course),
        child: CircleAvatar(backgroundImage: _getListImage(course)));
  }

  Widget _getSubtitle(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return Text("Added by ${course.user.username}");
    }

    return Text(
        "Added by ${course.user.profile.first} ${course.user.profile.last}");
  }

  ImageProvider _getListImage(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  double _tileHeight = 90;
  List<Course> _courses = [];
}
