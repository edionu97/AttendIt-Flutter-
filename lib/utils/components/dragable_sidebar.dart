import 'package:flutter/material.dart';

class DraggableSideBar extends StatefulWidget {
  DraggableSideBar({@required this.draggableInfo});

  @override
  _DraggableSideBarState createState() => _DraggableSideBarState();

  final Function draggableInfo;
}

class _DraggableSideBarState extends State<DraggableSideBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
        elevation: 20,
        child: Container(
          margin: EdgeInsets.all(1.5),
          height: MediaQuery.of(context).size.height / 2 - 70,
          width: 15,
          decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  bottomLeft: Radius.circular(45))),
          child: DragTarget(
            builder: (context, List<String> candidate, rejected) {
              if(rejected.isNotEmpty && !rejected[0].toString().contains("Absent")) {
                widget.draggableInfo(rejected[0]);
              }
              return Center(
                child: Container(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        "Drag element here to make absent",
                        style: TextStyle(fontSize: 12),
                      ),
                    )),
              );
            },
            onWillAccept: (data) {
              setState(() {});
              return false;
            },
          ),
        ),
      ),
    );
  }

  Color _color = Colors.transparent;
}
