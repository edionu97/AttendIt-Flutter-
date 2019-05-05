import 'package:attend_it/utils/loaders/loader.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {

  Loading({@required this.future, this.completed});

  @override
  _LoadingState createState() => _LoadingState();

  final Future future;
  final Function completed;
}

class _LoadingState extends State<Loading> {

  @override
  void initState(){
    super.initState();
    _displayed = Center(child: Loader(),);
    widget.future.then((value){
      if(!this.mounted){
        return;
      }
      setState(() {
        _displayed = widget.completed(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _displayed;
  }

  Widget _displayed;
}
