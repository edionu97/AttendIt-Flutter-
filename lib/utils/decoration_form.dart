import 'package:flutter/material.dart';

class Decorator {
  static BoxDecoration getDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[700],
          Colors.orange[600],
        ],
      ),
      borderRadius:
          new BorderRadius.only(bottomLeft: const Radius.circular(150)),
    );
  }
}