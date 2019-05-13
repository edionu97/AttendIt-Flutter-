import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
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
  void initState(){
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
              : _createView(context, ),
        ));
  }

  Widget _createView(final BuildContext context){
    return Center(child: Text("My courses"),);
  }

  void _getCourses() async {

    try{
      final List<Course> __courses = await CourseService().getCoursesPostedByTeacher(widget.username);
      
      print(__courses[0].name);
      if(!this.mounted){
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }on Exception catch(e){
      Future.delayed(Duration.zero,
              () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  bool _isLoading = true;
  List<Course> _courses = [];
}
