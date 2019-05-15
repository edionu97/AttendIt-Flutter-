import 'package:attend_it/users/common/service/profile_service.dart';
import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/drawer/collapsing.dart';
import 'package:attend_it/utils/drawer/navigation.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer(
      {this.selected = 0,
      @required this.onClose,
      @required this.selectionHandler,
      this.username,
        @required this.options
      });

  @override
  State<StatefulWidget> createState() {
    return _NavigationDrawer();
  }

  final Function onClose;
  final Function selectionHandler;
  final int selected;
  final String username;
  final List<NavigationModel> options;
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

    _heightAnimation =
        Tween<double>(begin: 40, end: 100).animate(_animationController);

    currentSelectedItem = widget.selected;

    _getProfilePicture();
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
      if (isCollapsed) {
        _animationController.forward();
        return;
      }
      _animationController.reverse().then((v) => widget.onClose());
    });
  }

  Widget _getWidget(final BuildContext context, final Widget wid) {

    final String __title = "Welcome ${widget.username.toUpperCase()}";

    return Material(
      elevation: 20,
      child: Opacity(
        opacity: .95,
        child: Container(
            width: widthAnimation.value,
            decoration: Decorator.getSimpleDecoration(),
            height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
              Divider(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: _heightAnimation.value - 10,
                    height: _heightAnimation.value - 10,
                    decoration: decoration,
                  ),
                  widthAnimation.value == closedWidth ?
                  Align(
                    alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          __title.length <= 18 ? __title : __title.substring(0, 16)+"...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                    ),
                  ) : Container()
                ],
              ),
              Divider(height: _heightAnimation.value - 60 >= 10 ? _heightAnimation.value - 60 : 10),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, counter) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentSelectedItem = counter;
                        });
                        widget.selectionHandler(counter);
                      },
                      child: CollapsingListTitle(
                        title: widget.options[counter].title,
                        icon: widget.options[counter].icon,
                        animationController: _animationController,
                        minWidth: openWidth,
                        maxWidth: closedWidth,
                        isSelected: currentSelectedItem == counter,
                      ),
                    );
                  },
                  itemCount: widget.options.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 40,
                      color: Colors.white70,
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
                    color: Colors.white,
                    size: 38.0,
                  )),
              SizedBox(
                height: 20,
              )
            ])),
      ),
    );
  }

  void _getProfilePicture() async {

    setState(() {
      this.decoration =  Decorator.getDefaultImageDecoration();
    });

    try {
      dynamic response = await profileService.getProfile(widget.username);

      if(response["image"] == null) {
        return;
      }

      if(!this.mounted){
        return;
      }

      setState(() {
        this.decoration = Decorator.getImageDecoration(
            response["image"]
        );
      });

    } on Exception {}

  }

  final double openWidth = 70;
  final double closedWidth = 185;
  int currentSelectedItem;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  Animation<double> _heightAnimation;
  BoxDecoration decoration;

  final ProfileService profileService = new ProfileService();
}
