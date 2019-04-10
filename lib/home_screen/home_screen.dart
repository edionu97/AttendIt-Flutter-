import 'package:attend_it/navigation_drawer/component.dart';
import 'package:attend_it/profile_screen/component.dart';
import 'package:attend_it/service/profile_service.dart';
import 'package:attend_it/upload_video_screen/component.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();

  final String username;
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widgetController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    controllerDrawer = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    widgetAnimation = Tween<double>(begin: 0, end: 1).animate(widgetController);

    drawerAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controllerDrawer);

    widgets = [
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Homescreen",
                style: TextStyle(fontSize: 20),
              ),
            )),
      ),
      Container(),
      Container(),
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Profile(username: widget.username)),
      ),
      FadeTransition(
        opacity: widgetAnimation,
        child: ScaleTransition(
            scale: widgetAnimation,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Attendence screen",
                style: TextStyle(fontSize: 20),
              ),
            )),
      )
    ];

    widgetController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    widgetController.dispose();
    controllerDrawer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          InkWell(
              onTap: () {
                if (!_isDrawerVisible) {
                  return;
                }
                controllerDrawer.reverse().then((f) => setState(() {
                      _isDrawerVisible = false;
                    }));
              },
              child: widgets[_selectedItem]),
          _isDrawerVisible
              ? _getNavigationDrawer()
              : _getNavigationDrawerButton()
        ],
      ),
    );
  }

  void _selection(final int index, final BuildContext context) {
    switch (index) {
      case 1:
        {
          _showCameraDialog(context);
          setState(() {
            _isDrawerVisible = false;
          });
          break;
        }

      case 2:
        {
          Navigator.pop(context);
          break;
        }

      default:
        {
          widgetController.reverse().then((f) {
            widgetController.forward();
            setState(() {
              _isDrawerVisible = false;
              _selectedItem = index;
            });
          });
        }
    }
  }

  void _showCameraDialog(final BuildContext context){

    showDialog(
        context: context,
        builder: (context){
          return Container(
            color: Colors.transparent,
            // container to set color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                      Video(),
                      Divider(height: 5,)
                  ]
              )
          );
        }
    );
  }

  Widget _getNavigationDrawerButton() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(top: 35, left: 15),
          child: InkWell(
            onTap: () {
              setState(() {
                controllerDrawer.reset();
                controllerDrawer.forward();
                _isDrawerVisible = !_isDrawerVisible;
              });
            },
            child: Icon(
              Icons.menu,
              size: 35,
            ),
          ),
        ));
  }

  Widget _getNavigationDrawer() {
    return Align(
      alignment: Alignment.topLeft,
      child: SlideTransition(
        position: drawerAnimation,
        child: NavigationDrawer(
            username: widget.username,
            selected: _selectedItem,
            selectionHandler: (idx) => controllerDrawer
                .reverse()
                .then((f) => _selection(idx, context)),
            onClose: () => controllerDrawer.reverse().then(
                (f) => setState(() => _isDrawerVisible = !_isDrawerVisible))),
      ),
    );
  }

  bool _isDrawerVisible = false;
  int _selectedItem = 0;
  List<Widget> widgets;

  AnimationController widgetController;
  AnimationController controllerDrawer;
  Animation<double> widgetAnimation;
  Animation<Offset> drawerAnimation;

  final ProfileService profileService = ProfileService();
}
