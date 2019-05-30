import 'package:attend_it/users/common/notifications/notificator.dart';
import 'package:attend_it/users/teacher/models/history.dart';
import 'package:attend_it/users/teacher/models/history_info.dart';
import 'package:attend_it/users/teacher/services/history_service.dart';
import 'package:attend_it/users/teacher/utils/attendance_info/component.dart';
import 'package:attend_it/utils/enums/notifications.dart';
import 'package:attend_it/utils/gui/gui.dart';
import 'package:attend_it/utils/loaders/loader.dart';
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

    Notificator().addObserver(_listener);
  }

  @override
  void dispose() {
    Notificator().removeObserver(_listener);
    super.dispose();
  }

  void _getHistory() async {
    try {
      _presents = await HistoryService().getHistoryForPresents(widget.username);
      setState(() {
        _isLoading = false;
      });
    } on Exception catch (e) {
      Future.delayed(Duration.zero,
          () => GUI.openDialog(context: context, message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: _isLoading
          ? Center(
              child: Loader(),
            )
          : _createView(
              context,
            ),
    ));
  }

  Widget _createView(final BuildContext context) {
    if (_presents.isEmpty) {
      return new Container(
        child: Center(
          child: Text("No data available"),
        ),
      );
    }

    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverAppBar(
            elevation: 9,
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.brown,
            floating: true,
            primary: true,
            forceElevated: true,
            leading: Container(),
            expandedHeight: MediaQuery.of(context).size.height / 3,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "recognition.jpg",
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            )),
        _presents.isNotEmpty
            ? SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                    (builder, index) =>
                        _createListItem(context, _presents[index]),
                    childCount: _presents.length),
                itemExtent: 95)
            : SliverFillRemaining(
                child: Center(child: Text("No data found")),
              ),
      ],
    );
  }

  Widget _createListItem(
      final BuildContext context, final HistoryInfo history) {
    final double _tileHeight = 90.0;

    return InkWell(
      onTap: () => this._showDialog(context, history),
      child: Card(
        elevation: 6,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: _tileHeight,
          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    history.group,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    history.courseType,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              title: Text(
                "${history.courseName} (${history.courseAbr})",
                style: TextStyle(
                    fontWeight: FontWeight.w300, fontFamily: "times new roman"),
              ),
              leading: _buildListLeading(context, history),
              subtitle: _getSubtitle(history),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSubtitle(final HistoryInfo history) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(history.attendanceDate.toLocal().toString().split(".")[0]),
    );
  }

  Widget _buildListLeading(
      final BuildContext context, final HistoryInfo history) {
    return CircleAvatar(backgroundImage: history.attendanceImage.image);
  }

  void _showDialog(final BuildContext cont, final HistoryInfo history) {
    final AttendanceInfo attendanceInfo = new AttendanceInfo(
      username: widget.username,
      historyInfo: history,
    );

    showDialog(
        context: cont,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => attendanceInfo.hide(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        attendanceInfo,
                        Divider(
                          height: 5,
                        )
                      ])),
            ),
          );
        });
  }

  void _listener(dynamic notification) {
    final NotificationType type =
        getNotificationTypeFromString(notification["type"]);

    if (type == NotificationType.SERVER_NOTIFICATION) {
      _getHistory();
    }
  }

  bool _isLoading = true;
  List<HistoryInfo> _presents = [];
}
