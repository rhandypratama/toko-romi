import 'package:flutter/material.dart';
import 'package:toko_romi/utils/widget-color.dart';

class WidgetBackground extends StatelessWidget {
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -124,
          right: -128,
          child: Container(
            width: 256.0,
            height: 256.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9000),
              // color: appColor.colorTertiary,
              color: Colors.yellow[700],
            ),
          ),
        ),
        Positioned(
          top: -164,
          right: -8.0,
          child: Container(
            width: 256.0,
            height: 256.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9000),
              backgroundBlendMode: BlendMode.hardLight,
              color: Colors.yellowAccent.withOpacity(0.8),
            ),
          ),
        )
      ],
    );
  }
}