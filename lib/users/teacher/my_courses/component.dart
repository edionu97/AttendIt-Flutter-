import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/profile.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/components/round_bottom_button.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key key, this.username, this.function}) : super(key: key);

  @override
  _MyCoursesState createState() => _MyCoursesState();

  final String username;
  final Function function;
}

class _MyCoursesState extends State<MyCourses> {
  @override
  void initState() {
    super.initState();

    this._getCourses();
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
      Transform.translate(
        offset: Offset(0,5),
        child: RoundBorderButton(
          onTap: widget.function,
          splashColor: Colors.brown[700],
          buttonColor: Colors.brown[500],
          iconColor: Colors.white,
          buttonIcon: Icons.add,
        ),
      )
    ]);
  }

  Widget _createListItem(final BuildContext context, final Course course) {
    final double _tileHeight = 90.0;

    return Card(
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
    );
  }

  Widget _buildListLeading(final BuildContext context, final Course course) {
    return CircleAvatar(backgroundImage: _getListImage(course));
  }

  Widget _getSubtitle(final Course course) {
    final Profile profile = course.user.profile;

    if (profile == null) {
      return Text("Added by you");
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

  bool _isLoading = true;
  List<Course> _courses = [];
}
