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

  static getSimpleDecoration(){
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

    );
  }

  static BoxDecoration getDialogDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.white70,
            Colors.white70,
            Colors.white70,
            Colors.white70,
          ],
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(80),
            bottomRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)));
  }

  static BoxDecoration getImageDecoration(final Image img){
      return BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(image: img.image)
      );
  }

  static BoxDecoration getDefaultImageDecoration() {
    return new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("user.png"),
        ));
  }
}
