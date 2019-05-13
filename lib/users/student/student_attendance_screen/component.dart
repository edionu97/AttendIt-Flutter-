import 'package:attend_it/users/student/service/attendance_service.dart';
import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/profile.dart';
import 'package:attend_it/utils/components/loading.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/gui/gui.dart';
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

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Loading(
        future: AttendanceService().getAllAvailableCourses().catchError(
            (error) => Future.delayed(
                Duration.zero,
                () => GUI.openDialog(
                    context: context, message: error.toString()))),
        completed: (final List<Course> courses) =>
            _createView(context, courses),
      ),
    ));
  }

  void _openInfoDialog(final BuildContext cont, final Course course) {

    final Enroll enroll = Enroll(
      course: course,
      username: widget.username,
    );

    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => enroll.hide(),
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        enroll,
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

    if(courses.isEmpty){
      return Center(child: Text("No data to be displayed"),);
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

    final double _tileHeight = 90.0;

    return InkWell(
      onTap: () => _openInfoDialog(context, course),
      child: Card(
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
      ),
    );
  }

  Widget _buildListLeading(final BuildContext context, final Course course) {
    return CircleAvatar(backgroundImage: _getListImage(course));
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
}
