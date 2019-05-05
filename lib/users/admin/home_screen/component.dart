import 'package:attend_it/main.dart';
import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/student/service/login_service.dart';
import 'package:attend_it/users/student/service/models/profile.dart';
import 'package:attend_it/users/student/service/models/user.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatefulWidget {
  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  @override
  void initState() {
    super.initState();
    //Notificator().setOnDone(() => _restartApp());
    _getUsers();
    Notificator().setOnDone((){
      _restartApp();
    });
    Notificator().addObserver(_notified);
  }

  @override
  void dispose(){
    Notificator().removeObserver(_notified);
    super.dispose();
  }

  void _getUsers() async {
    try {
      final List<User> _users = await LoginService().getUsers();

      if (!this.mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        this._users = _users;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _isLoading
              ? Center(
                  child: Loader(),
                )
              : Container(
                  padding: EdgeInsets.only(top: 50), child: _buildList(_users)),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 35, right: 15),
                height: 35,
                width: 35,
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  elevation: 30,
                  child: Container(
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      onTap: _logout,
                      child: Icon(Icons.close, size: 35, color: Colors.red),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildList(final List<User> courses) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, courses[index]));
  }

  Widget _buildListItem(final BuildContext context, final User user) {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            trailing: _getTrailing(user, context),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _getTitle(user),
            ),
            leading: _buildListLeading(context, user),
            subtitle: Text("${user.role}"),
          ),
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
      height: 60,
      width: 60,
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

  Widget _getTrailing(final User user, final BuildContext context) {
    if (user.role != "UNDEFINED") {
      return Container(
        height: 20,
        width: 20,
      );
    }

    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => this._setUserRole(user, "TEACHER", context),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              height: 20,
              width: 20,
              child: Icon(Icons.school, size: 20, color: Colors.blueGrey),
            ),
          ),
        ),
        SizedBox(
          height: 10,
          width: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onTap: () => this._setUserRole(user, "STUDENT", context),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              height: 20,
              width: 20,
              child: Icon(Icons.person, size: 20, color: Colors.blueGrey),
            ),
          ),
        ),
      ],
    );
  }

  void _restartApp() {
    Notificator().close();
    RestartWidget.restartApp(context);
  }

  void _setUserRole(
      final User user, final String role, final BuildContext context) async {

    try{
      await LoginService().setRole(user.username, role);

      Notificator().sendOnlyTo([Constants.ADMIN], {
        "type": NotificationType.ACCOUNT_CONFIRMED_REFRESH.toString(),
        "data": {
          "role": role,
          "usern": user.username
        }
      });

      Notificator().sendOnlyTo([user.username], {
        "type": NotificationType.ACCOUNT_CONFIRMED.toString(),
        "data": {
          "role": role,
          "usern": user.username
        }
      });
    }on Exception catch(e){
      Future.delayed(Duration.zero,
              () => GUI.openDialog(context: context, message: e.toString()));
    }

  }


  ImageProvider _getListImage(final User user) {
    final Profile profile = user.profile;

    if (profile == null) {
      return AssetImage("user.png");
    }

    return profile.image.image;
  }

  void _logout() {
    Notificator().setOnDone(() {});
    Notificator().close();
    Navigator.of(context).pop();
  }


  void _notified(dynamic notification){

    final NotificationType type = getNotificationTypeFromString(notification["type"]);

    if(type == NotificationType.ACCOUNT_CONFIRMED_REFRESH){
      final String userRole = notification["data"]["role"];
      final String usern = notification["data"]["usern"];

      List<User> __users = [];
      _users.forEach((usr) {
        if(usr.username == usern){
          usr.role = userRole;
        }
        __users.add(usr);
      });

      setState(() {
        _users = __users;
      });
    }

    if(type == NotificationType.NEW_REGISTRATION){
      final String usern = notification["data"]["usern"];
      print('notified');
      _users.insert(0, User(
          role: "UNDEFINED",
          profile: null,
          username: usern
      ));
      setState(() {
        this._users = _users;
      });
    }
  }

  bool _isLoading = true;
  List<User> _users = [];
}
