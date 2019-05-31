import 'package:attend_it/users/common/models/course.dart';
import 'package:attend_it/users/common/models/profile.dart';
import 'package:attend_it/users/common/models/user.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/common/service/profile_service.dart';
import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class Enrolled extends StatefulWidget {
  Enrolled({this.course});

  @override
  _EnrolledState createState() => _EnrolledState();

  void hide() {
    if (list.length == 0) {
      return;
    }

    final _EnrolledState _enrolledState = list[0];
    _enrolledState.hide();
  }

  final Course course;
  final List<_EnrolledState> list = [];
}

class _EnrolledState extends State<Enrolled> with TickerProviderStateMixin {
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

    _getEnrolledStudents();

    Notificator().addObserver(this._notified);
  }

  @override
  void dispose() {
    _animationController.dispose();
    Notificator().removeObserver(this._notified);
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
      onDoubleTap: () {
        _animationController.reverse().then((_) => Navigator.of(context).pop());
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
                  height: MediaQuery.of(context).size.height / 2,
                  width: 300,
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
            : _createView(context, _users));
  }

  Widget _createView(final BuildContext context, final List<User> users) {
    if (users.isEmpty) {
      return Center(child: Text("No data to be displayed"));
    }

    final BorderRadius radius = BorderRadius.only(
        topLeft: Radius.circular(25), topRight: Radius.circular(25));

    return Stack(
      children: <Widget>[
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              elevation: 2,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "${widget.course.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.centerLeft, child: _buildList(users)),
            ),
            Divider(
              height: 1,
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "You have ${_users.length} enrolled ${(_users.length > 1 ? "students" : "student")}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildList(final List<User> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => _buildListItem(context, users[index]));
  }

  Widget _buildListItem(final BuildContext context, final User user) {
    return Card(
      elevation: 5,
      child: Container(
        child: ListTile(
          dense: true,
          trailing: Text(
            user.username,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: user.profile != null ? _getTitle(user) : Text("Unspecified"),
          ),
          leading: _buildListLeading(context, user),
          subtitle: _getSubtitle(user, context),
        ),
      ),
    );
  }

  Widget _getTitle(final User user) {
    final Profile profile = user.profile;

    if (profile == null) {
      return Text("Username ${user.username}");
    }

    return Text("${user.profile.first} ${user.profile.last}");
  }

  Widget _buildListLeading(final BuildContext context, final User user) {
    return Container(
      height: 50,
      width: 50,
      child: Material(
        elevation: 10,
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: CircleAvatar(
          backgroundImage: _getListImage(user),
        ),
      ),
    );
  }

  ImageProvider _getListImage(final User user) {
    final Profile profile = user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  Widget _getSubtitle(final User attendance, BuildContext context) {
    return Text(attendance.role);
  }

  void _getEnrolledStudents() async {
    try {
      _users = await CourseService().getEnrollmentsAtCourse(
          widget.course.user.username, widget.course.name, widget.course.type);

      if (!this.mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  void hide() {
    _animationController.reverse().then((_) => Navigator.of(context).pop());
  }

  void _notified(final dynamic notification) {
    final NotificationType type =
        getNotificationTypeFromString(notification["type"]);

    switch (type) {
      case NotificationType.STUDENT_ENROLLED:
        final Course course = Course.fromJson(notification["data"]["course"]);

        if (course.type != widget.course.type ||
            course.name != widget.course.name) {
          return;
        }

        __addNewEnrolledStudent(notification["data"]["usern"], "STUDENT");

        break;
      case NotificationType.STUDENT_ENROLL_CANCELED:
        final Course course = Course.fromJson(notification["data"]["course"]);

        if (course.type != widget.course.type ||
            course.name != widget.course.name) {
          return;
        }

        final int index = _users
            .indexWhere((usr) => usr.username == notification["data"]["usern"]);

        if (index == -1) {
          return;
        }

        _users.removeAt(index);

        setState(() {});
        break;

      default:
        break;
    }
  }

  void __addNewEnrolledStudent(final String username, final String role) async {
    try {
      print(username);
      final dynamic response = await ProfileService().getProfile(username);

      final User user = new User(
          role: role,
          username: username,
          profile: response["image"] != null
              ? new Profile(
                  email: response["email"],
                  first: response["first"],
                  last: response["last"],
                  phone: response["phone"],
                  image: response["image"])
              : null);

      _users.add(user);
      if (!this.mounted) {
        return;
      }

      setState(() {});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  AnimationController _animationController;
  Animation<Offset> _animation2;
  Animation<double> _animation1;

  bool _isLoading = true;
  List<User> _users = [];
}
