import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/profile.dart';
import 'package:attend_it/users/common/models/user.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/teacher/add_course/component.dart';
import 'package:attend_it/users/teacher/enrolled/component.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key key, this.username}) : super(key: key);

  @override
  _MyCoursesState createState() => _MyCoursesState();

  final String username;
}

class _MyCoursesState extends State<MyCourses> {
  @override
  void initState() {
    super.initState();

    this._getCourses();
    Notificator().addObserver(_listener);
  }

  @override
  void dispose() {
    Notificator().removeObserver(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: _isLoading
          ? Center(
              child: Loader(),
            )
          : _createView(
              context,
            ),
    ));
  }

  Widget _createView(final BuildContext context) {
    return Stack(children: <Widget>[
      CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
              elevation: 5,
              pinned: true,
              centerTitle: true,
              backgroundColor: Colors.brown,
              floating: true,
              primary: true,
              forceElevated: true,
              leading: Container(),
              expandedHeight: MediaQuery.of(context).size.height / 3.5,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "courses.jpg",
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              )),
          SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                  (builder, index) => _createListItem(context, _courses[index]),
                  childCount: _courses.length),
              itemExtent: 95),
        ],
      ),
      !_isAddActive
          ? RoundBorderButton(
              onTap: () => this._buttonAddClicked(context),
              splashColor: Colors.brown[700],
              buttonColor: Colors.brown[500],
              iconColor: Colors.white,
              buttonIcon: Icons.add,
            )
          : Container()
    ]);
  }

  Widget _createListItem(final BuildContext context, final Course course) {
    final double _tileHeight = 90.0;

    return InkWell(
      onTap: () => _itemClicked(context, course),
      child: Card(
        elevation: 6,
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

  void _itemClicked(final BuildContext cont, final Course course) async {
    final Enrolled enrolled = new Enrolled(
      course: course,
    );

    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => enrolled.hide(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        enrolled,
                        Divider(
                          height: 5,
                        )
                      ])),
            ),
          );
        });
  }

  Widget _getSubtitle(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return Text("Added by you");
    }

    return Text(
        "Added by you, ${course.user.profile.first} ${course.user.profile.last}");
  }

  ImageProvider _getListImage(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  void _buttonAddClicked(final BuildContext cont) async {
    final AddCourse addCourse = new AddCourse(
      username: widget.username,
    );

    setState(() {
      _isAddActive = true;
    });

    await showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => addCourse.hide(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        addCourse,
                        Divider(
                          height: 5,
                        )
                      ])),
            ),
          );
        });

    setState(() {
      _isAddActive = false;
    });
  }

  void _getCourses() async {
    try {
      final List<Course> __courses =
          await CourseService().getCoursesPostedByTeacher(widget.username);

      if (!this.mounted) {
        return;
      }

      setState(() {
        _courses = __courses;
        _isLoading = false;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  void _listener(final dynamic notification) {
    final NotificationType type =
        getNotificationTypeFromString(notification["type"]);

    if (type == NotificationType.COURSE_ADDED_REFRESH) {
      final dynamic courseData = notification["data"]["course"];
      final User user = _courses.isEmpty ? null : _courses[0].user;
      _courses.add(new Course(
          name: courseData["name"], type: courseData["type"], user: user));
      setState(() {
        this._courses = _courses;
      });
    }
  }

  bool _isLoading = true;
  bool _isAddActive = false;
  List<Course> _courses = [];
}
