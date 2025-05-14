import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils.lightColorSecond.withAlpha(20);
    return Stack(
      children: [
        Positioned(
          left: -150,
          top: 300,
          child: FadeInLeft(child: Transform.rotate(angle: 120, child: Container(width: 300, height: 400, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20))))),
        ),
        Positioned(right: -80, top: -100, child: FadeInDown(child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: color)))),
        Positioned(right: 0, bottom: -100, child: FadeInUp(child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: color)))),
      ],
    );
  }
}
