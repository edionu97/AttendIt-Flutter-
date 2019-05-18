import 'dart:math';

import 'package:attend_it/users/teacher/services/course_service.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class SelectGroup extends StatefulWidget {
  SelectGroup({this.username});

  @override
  _SelectGroupState createState() => _SelectGroupState();

  final String username;
}

class _SelectGroupState extends State<SelectGroup> {
  @override
  void initState() {
    super.initState();

    this._getClasses();
  }

  void _getClasses() async {
    try {
      _classes = await CourseService().getDistinctClasses(widget.username);

      setState(() {
        _isLoading = false;
      });

      _colors = await this._setColorToClasses(_classes);
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  Future<Map<String, Color>> _setColorToClasses(
      final List<String> classes) async {
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

    classes.forEach((_class) {
      _selected.putIfAbsent(_class, () => 0);

      if(_selectedGroup == null){
        _selectedGroup = _class;
        _selected[_class] = 6;
      }

      colors.putIfAbsent(
          _class, () => primaryColors[random.nextInt(primaryColors.length)]);
    });

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(20));
    return Material(
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
              "Select a class",
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
                child: _buildList(_classes))),
        Container(
          height: 25,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _selectedGroup == null ? "" : "Selected ($_selectedGroup)",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList(final List<String> _grups) {
    if (_grups.isEmpty) {
      return Center(
        child: Text(
          "No data to be displayed. ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
      );
    }
    return ListView.builder(
      primary: true,
      itemCount: _grups.length,
      itemBuilder: (context, index) => _createListItem(context, _grups[index]),
    );
  }

  Widget _createListItem(final BuildContext context, final String group) {
    return Card(
      elevation: _selected[group],
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _grupClicked(group),
        child: ListTile(
          dense: true,
          trailing: Text(
            "CLS NO.",
            style: TextStyle(color: Colors.black38, fontSize: 12),
          ),
          leading: _buildListLeading(context, group),
        ),
      ),
    );
  }

  Widget _buildListLeading(final BuildContext context, final String _class) {
    return Container(
      height: 35,
      width: 35,
      child: Material(
        color: _colors[_class],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            _class.toUpperCase(),
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

  void _grupClicked(final String grup) {
    if (_selectedGroup != null) {
      _selected[_selectedGroup] = 0;
    }

    _selectedGroup = grup;
    _selected[grup] = 6;

    setState(() {});
  }

  List<String> _classes = [];
  Map<String, double> _selected = {};
  Map<String, Color> _colors = {};
  String _selectedGroup;
  bool _isLoading = true;
}
