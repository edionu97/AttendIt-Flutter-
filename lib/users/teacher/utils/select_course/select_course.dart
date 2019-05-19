import 'dart:math';

import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class SelectCourse extends StatefulWidget {
  SelectCourse({this.username});

  @override
  _SelectCourseState createState() => _SelectCourseState();

  final String username;
}

class _SelectCourseState extends State<SelectCourse> {
  @override
  void initState() {
    super.initState();

    this._getCourses();
  }

  void _getCourses() async {
    try {
      _courses =
          await CourseService().getCoursesPostedByTeacher(widget.username);

      if (!this.mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _colors = await this._setColorsToCourses(_courses);

      setState(() {});
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Future<Map<String, Color>> _setColorsToCourses(
      final List<Course> courses) async {
    final Map<String, Color> colors = {};

    final List<Color> primaryColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
    ];
    final Random random = new Random();

    courses.forEach((course) {
      _selected.putIfAbsent(
          "${course.abbreviation}_${course.name}_${course.type}", () => 0);

      if(_selectedCourse == null){
        _selectedCourse = course;
        _selected["${course.abbreviation}_${course.name}_${course.type}"] = 6;
      }

      colors.putIfAbsent(course.abbreviation,
          () => primaryColors[random.nextInt(primaryColors.length)]);
    });

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(20));
    return Material(
      borderRadius: radius,
      child: Center(
        child: Container(
            height: 250,
            width: 180,
            child: Material(
                color: Colors.white,
                elevation: 5,
                borderRadius: radius,
                child: _isLoading
                    ? Center(
                        child: Loader(),
                      )
                    : _buildView(context))),
      ),
    );
  }

  Widget _buildView(final BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Select a course",
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "times new roman",
                  fontStyle: FontStyle.normal),
            )),
          ),
        ),
        Divider(
          height: .4,
          color: Colors.black38,
        ),
        Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildList(_courses))),
        Container(
          height: 25,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _selectedCourse == null
                    ? "Nothing selected"
                    : "Selected ${_selectedCourse.abbreviation.toUpperCase()} (${_selectedCourse.type})",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList(final List<Course> courses) {
    return ListView.builder(
      primary: true,
      itemCount: courses.length,
      itemBuilder: (context, index) => _createListItem(context, courses[index]),
    );
  }

  Widget _createListItem(final BuildContext context, final Course course) {
    return Card(
      elevation:
          _selected["${course.abbreviation}_${course.name}_${course.type}"],
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _courseClicked(course),
        child: ListTile(
          dense: true,
          trailing: Text(
            course.type.toUpperCase(),
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
          leading: _buildListLeading(context, course),
        ),
      ),
    );
  }

  Widget _buildListLeading(final BuildContext context, final Course course) {
    return Container(
      height: 35,
      width: 35,
      child: Material(
        color: _colors[course.abbreviation],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            course.abbreviation.toUpperCase(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
      ),
    );
  }

  void _courseClicked(final Course course) {
    if (_selectedCourse != null) {
      _selected[
          "${_selectedCourse.abbreviation}_${_selectedCourse.name}_${_selectedCourse.type}"] = 0;
    }

    _selectedCourse = course;

    _selected["${course.abbreviation}_${course.name}_${course.type}"] = 6;
    setState(() {});
  }

  List<Course> _courses = [];
  Map<String, Color> _colors = {};
  Map<String, double> _selected = {};
  Course _selectedCourse;
  bool _isLoading = true;
}
