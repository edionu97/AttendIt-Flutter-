import 'dart:convert';

import 'package:attend_it/users/teacher/models/history.dart';
import 'package:attend_it/users/teacher/models/history_info.dart';
import 'package:attend_it/utils/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HistoryService {
  HistoryService._();

  Future<List<HistoryInfo>> getHistoryForPresents(final String username) async {
    final List<HistoryInfo> list = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.ATTENDANCE_HISTORY,
            body: json.encode({"usern": username}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            final dynamic body = json.decode(response.body);
            throw new Exception(body["msg"]);
          }
          return response;
        });

    //get all history entries
    final List<History> historyList = [];
    final dynamic history = (json.decode(response.body))["history"];
    history.forEach((hst) {
      historyList.add(History.fromJson(hst));
    });

    for (final History hist in historyList) {
      final List<HistoryInfo> _historyInfo = await getHistoryInfoFor(hist.teacherName, hist.historyId);

      if(_historyInfo.isEmpty){
        continue;
      }

      list.add(_historyInfo[0]);
    }

    return list;
  }

  Future<List<HistoryInfo>> getHistoryForAt(
      final String username, final int id) async {
    final List<HistoryInfo> list = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.ATTENDANCE_HISTORY_AT,
            body: json.encode({"usern": username, "id": id}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            final dynamic body = json.decode(response.body);
            throw new Exception(body["msg"]);
          }
          return response;
        });

    final dynamic history = (json.decode(response.body))["history"];
    history.forEach((hst) {
      list.add(HistoryInfo.fromJson(hst));
    });

    return list;
  }

  Future<List<HistoryInfo>> getHistoryInfoFor(
      final String username, final int historyId) async {
    final List<HistoryInfo> list = [];

    final Response response = await http
        .post(Constants.SERVER_ADDRESS + Constants.ATTENDANCE_HISTORY_AT,
            body: json.encode({"usern": username, "id": historyId}),
            headers: {"Content-Type": "application/json"})
        .timeout(const Duration(minutes: 5))
        .catchError((error) =>
            throw new Exception("Could not get any response from server"))
        .then((Response response) {
          if (response.statusCode != 200) {
            final dynamic body = json.decode(response.body);
            throw new Exception(body["msg"]);
          }
          return response;
        });

    final dynamic history = (json.decode(response.body))["history"];

    history.forEach((hst) {
      list.add(HistoryInfo.fromJson(hst));
    });

    return list;
  }

  factory HistoryService() {
    return _instance;
  }

  static final HistoryService _instance = new HistoryService._();
}
