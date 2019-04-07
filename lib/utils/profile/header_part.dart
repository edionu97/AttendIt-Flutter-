

import 'package:attend_it/utils/components/decoration_form.dart';
import 'package:attend_it/utils/profile/round_image.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {

  Header({this.onPress, this.image, @required this.height, @required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: Decorator.getAllRoundedCornersDecoration(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 140,
                width: 140,
                alignment: Alignment.center,
                decoration: this.image == null ? Decorator.getDefaultImageDecoration() : Decorator.getImageDecoration(image),
                  child: InkWell(
                      child: AssetRoundImage(imageName:"photo-camera.png"),
                      onTap: (){
                        if(this.onPress == null){
                          return;
                        }
                        this.onPress();
                      },
                  )
                )

            ],
        ),
    );
  }

  final Function onPress;
  final Image image;
  final double height, width;
}