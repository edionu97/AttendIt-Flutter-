import 'package:attend_it/users/teacher/models/history_info.dart';
import 'package:attend_it/users/teacher/services/history_service.dart';
import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AttendantStudents extends StatefulWidget {
  AttendantStudents({this.historyInfo, this.username, this.isAbsent});

  @override
  _AttendantStudentsState createState() => _AttendantStudentsState();

  final HistoryInfo historyInfo;
  final String username;
  final isAbsent;

  void addHistoryInList(final HistoryInfo historyInfo) {
    list[0].addInList(historyInfo);
  }

  List<HistoryInfo> getList(){
    return list[0].getList();
  }

  HistoryInfo getHistoryInfo(final String username) {
    return list[0].getHistoryInfoByUserName(username);
  }

  void removeHistoryInfo(final String username) {
    list[0].removeHistoryInfo(username);
  }

  final List<_AttendantStudentsState> list = [];
}

class _AttendantStudentsState extends State<AttendantStudents> {
  @override
  void initState() {
    super.initState();
    this._getPresentStudents();
    widget.list.add(this);
  }

  void _getPresentStudents() async {
    try {
      _attendanceInfo = !widget.isAbsent
          ? await HistoryService()
              .getHistoryInfoFor(widget.username, widget.historyInfo.historyId)
          : await HistoryService().getHistoryAbsents(widget.historyInfo);

      _attendanceInfo.removeWhere((x) =>  x.studentName == null);

      _isLoading = false;
      setState(() {});
    } on Exception {}
  }

  void addInList(HistoryInfo data) {
    _attendanceInfo.add(data);
    //reload in next frame
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void removeHistoryInfo(final String username) {
    _attendanceInfo.removeWhere((x) => x.studentName == username);
    //reload in next frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!this.mounted) {
        return;
      }
      setState(() {});
    });
  }

  List<HistoryInfo> getList(){
    return _attendanceInfo;
  }

  HistoryInfo getHistoryInfoByUserName(final String username) {
    return _attendanceInfo.firstWhere((x) => x.studentName == username,
        orElse: () => null);
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.all(Radius.circular(20));
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: Center(
        child: Container(
            height: 160,
            width: 185,
            child: Material(
                color: Colors.white,
                elevation: 20,
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
    if (_attendanceInfo.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.all(8.0), child: _buildList(_attendanceInfo)),
        ),
      ],
    );
  }

  Widget _buildList(final List<HistoryInfo> history) {
    return ListView.builder(
      primary: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final Widget widget = _createListItem(context, history[index]);
        return Draggable(
          child: widget,
          feedback: widget,
          childWhenDragging: Container(),
          axis: Axis.horizontal,
          data: this.widget.isAbsent
              ? "Absent: ${history[index].studentName}"
              : "Present: ${history[index].studentName}",
        );
      },
    );
  }

  Widget _createListItem(
      final BuildContext context, final HistoryInfo historyInfo) {
    return Container(
      height: 56,
      width: 200,
      child: Card(
        elevation: 20,
        child: ListTile(
          dense: true,
          title: Text(
            historyInfo.studentProfile != null
                ? "${historyInfo.studentProfile.first} ${historyInfo.studentProfile.last} "
                : "${historyInfo.studentName}",
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                historyInfo.studentName,
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                historyInfo.group,
                style: TextStyle(color: Colors.black87, fontSize: 8),
              )
            ],
          ),
          leading: _buildListLeading(context, historyInfo),
        ),
      ),
    );
  }

  Widget _buildListLeading(
      final BuildContext context, final HistoryInfo history) {
    return Container(
      height: 35,
      width: 35,
      child: Material(
          child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: history.studentProfile != null
                    ? history.studentProfile.image.image
                    : AssetImage("user.png"))),
      )),
    );
  }

  bool _isLoading = true;
  List<HistoryInfo> _attendanceInfo = [];
}
