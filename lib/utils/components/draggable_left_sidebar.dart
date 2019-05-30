import 'package:flutter/material.dart';

class DraggableLeftSideBar extends StatefulWidget {

  DraggableLeftSideBar({@required this.draggedInside});

  @override
  _DraggableLeftSideBarState createState() => _DraggableLeftSideBarState();

  final Function draggedInside;
}

class _DraggableLeftSideBarState extends State<DraggableLeftSideBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 3),
        child: Material(
          elevation: 20,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          child: Container(
            margin: EdgeInsets.all(1.5),
            height: MediaQuery
                .of(context)
                .size
                .height / 2 - 70,
            width: 15,
            decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: DragTarget(
              builder: (context, List<String> candidate, rejected) {
                if (rejected.isEmpty) {
                  return Center(
                    child: Container(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            "Drag element here to make present",
                            style: TextStyle(fontSize: 12),
                          ),
                        )),
                  );
                }

                if (rejected[0].toString().contains("Present")) {
                  return Center(
                    child: Icon(
                      Icons.clear,
                      size: 15,
                      color: Colors.black,
                    ),
                  );
                }
                widget.draggedInside(rejected[0]);
                return Center(
                  child: Icon(
                    Icons.check,
                    size: 15,
                    color: Colors.black,
                  ),
                );
              },
              onWillAccept: (data) {
                setState(() {});
                return false;
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _color = Colors.transparent;
}
