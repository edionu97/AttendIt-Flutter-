import 'package:attend_it/service/attendance_service.dart';
import 'package:attend_it/service/models/course.dart';
import 'package:attend_it/service/models/profile.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:attend_it/utils/student_attendance_screen/enroll.dart';
import 'package:flutter/material.dart';

class StudentAttendanceScreen extends StatefulWidget {
  StudentAttendanceScreen({this.username});

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();

  final String username;
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder<List<Course>>(
              future: AttendanceService().getAllAvailableCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: Loader());
                }
                return _createView(context, snapshot.data);
              })),
    );
  }

  Widget _createView(final BuildContext context, final List<Course> courses) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(0));

    return Container(
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
    ));
  }

  Widget _buildList(final List<Course> courses) {
    return ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey, height: 5),
        itemCount: courses.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, courses[index]));
  }

  Widget _buildListItem(final BuildContext context, final Course course) {
    return Center(
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(2),
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
    );
  }

  Widget _buildListLeading(final BuildContext context, final Course course) {
    return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: () => _openInfoDialog(context, course),
        child: CircleAvatar(backgroundImage: _getListImage(course)));
  }


  ImageProvider _getListImage(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  void _openInfoDialog(final BuildContext cont, final Course course){

    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Enroll(course: course, username: widget.username,),
                        Divider(height: 5,)
                      ])),
            ),
          );
        });

  }

  Widget _getSubtitle(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return Text("Added by ${course.user.username}");
    }

    return Text(
        "Added by ${course.user.profile.first} ${course.user.profile.last}");
  }
}
