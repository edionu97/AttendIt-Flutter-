import 'dart:convert';

import 'package:attend_it/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

class Notificator {
  Notificator._();

  /*
    Set username for for the current websocket client
   */
  void setUsername(final String username) {
    this._username = username;
    this._connect();
  }

  void setOnDone(final Function onDone){
    this._onDone = onDone;
  }

  /*
    Add listener that will be notified when data arrives
   */
  void addObserver(final Function function) {
    this._observers.add(function);
  }

  /*
    Send data to all connected clients
   */
  void sendToAll(final dynamic data) {
    _sendMessage({"sendTo": [], "userData": "\"" + json.encode(data) + "\""});
  }

  /*
    Send data only to the specified users
   */
  void sendOnlyTo(final List<String> users, final dynamic data) {
    _sendMessage(
        {"sendTo": users, "userData": "\"" + json.encode(data) + "\""});
  }

  /*
    Close the websocket connection
   */
  void close() async {
    await _channel.sink.close();
  }

  void _connect() {
    _channel = IOWebSocketChannel.connect(Constants.WEB_SOCKET);

    _sendMessage({
      "userInfo": {"usern": this._username}
    });

    print('Client ${this._username} connected!');

    _channel.stream.listen((data) => _notifyAllObservers(data),
        onError: (error, stacktrace) {
      print("ERROR->" + error);
    }, onDone: () {
      print("Connection closed for: ${this._username}");

      print(this._onDone);
      if(this._onDone == null){
        return;
      }
      this._onDone();
    });
  }

  void _sendMessage(final dynamic message) {
    this._channel.sink.add(json.encode(message));
  }

  void _notifyAllObservers(dynamic data) {
    final String dataString = data.toString();

    this._observers.forEach((observer) =>
        observer(json.decode(dataString.substring(1, dataString.length - 1))));
  }

  factory Notificator() {
    return Notificator._instance;
  }

  String _username;
  Function _onDone;
  IOWebSocketChannel _channel;
  ObserverList<Function> _observers = new ObserverList<Function>();

  static final Notificator _instance = Notificator._();
}
