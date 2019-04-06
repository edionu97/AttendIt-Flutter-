
import 'package:flutter/material.dart';

class AssetRoundImage extends StatelessWidget{

  AssetRoundImage({this.imageName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 40,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 20,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("photo-camera.png")
                        )
                    ),
                  )
                ],
              ),
            )
        )
      ],
    );
  }

  final String imageName;
}