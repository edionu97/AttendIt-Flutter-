import 'package:attend_it/users/teacher/models/history.dart';
import 'package:attend_it/users/teacher/services/history_service.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({this.username});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();

  final String username;
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    this._getHistory();
  }

  void _getHistory() async {
    try {
      history = await HistoryService().getHistoryFor(widget.username);
      setState(() {});
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
              () => GUI.openDialog(context: context, message: e.toString()));
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
      child: Center(
        child: Text(history.length.toString()),
      ),
    ));
  }


  List<History> history = [];
}
