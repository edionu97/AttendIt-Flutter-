import 'package:attend_it/navigation_drawer/component.dart';
import 'package:attend_it/profile_screen/component.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();

  final String username;
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Profile(username: widget.username,),
        _isDrawerVisible
            ? Align(
                alignment: Alignment.topLeft,
                child: NavigationDrawer(
                    onClose: () => setState(() {
                          _isDrawerVisible = !_isDrawerVisible;
                        })),
              )
            : Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 35, left: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isDrawerVisible = !_isDrawerVisible;
                      });
                    },
                    child: Icon(Icons.menu, size: 35,),
                  ),
                ))
      ],
    ));
  }

  bool _isDrawerVisible = false;
}
