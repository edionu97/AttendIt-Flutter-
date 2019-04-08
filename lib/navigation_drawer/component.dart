import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/drawer/collapsing.dart';
import 'package:attend_it/utils/drawer/navigation.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {

  NavigationDrawer({this.onClose});

  @override
  State<StatefulWidget> createState() {
    return _NavigationDrawer();
  }

  final Function onClose;
}

class _NavigationDrawer extends State<NavigationDrawer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: openWidth, end: closedWidth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => _getWidget(context, widget),
    );
  }

  void _drawerToggleClicked(final BuildContext context) {
    setState(() {
        isCollapsed = !isCollapsed;
        if(isCollapsed){
          _animationController.forward();
          return;
        }
        _animationController.reverse().then((v) => widget.onClose());
    });
  }

  Widget _getWidget(final BuildContext context, final Widget widget) {
    return Container(
        width: widthAnimation.value,
        decoration: Decorator.getSimpleDecoration(),
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Divider(height: 40),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, counter) {
                return CollapsingListTitle(
                    title: navigationOptions[counter].title,
                    icon: navigationOptions[counter].icon,
                    animationController: _animationController,
                    minWidth: openWidth,
                    maxWidth: closedWidth,
                );
              },
              itemCount: navigationOptions.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 40,
                  color: Colors.grey,
                );
              },
            ),
          ),
          InkWell(
              onTap: () {
                _drawerToggleClicked(context);
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
                color: Colors.white70,
                size: 38.0,
              )),
            SizedBox(height: 20,)
        ]));
  }

  final double openWidth = 70;
  final double closedWidth = 150;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
}
