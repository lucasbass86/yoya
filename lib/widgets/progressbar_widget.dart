import 'package:flutter/material.dart';
import 'package:yoya/utils/utils.dart';

class ProgressBarWidget extends StatelessWidget {
  final int currentValue;
  final int maxValue;
  final double width;
  final double height;
  final bool showPercentText;
  final Color backgroundColor;
  final Color progressColor;

  const ProgressBarWidget({
    super.key,
    required this.currentValue,
    required this.maxValue,
    this.width = double.infinity,
    this.height = 20,
    this.showPercentText = true,
    this.backgroundColor = Colors.grey,
    this.progressColor = const Color.fromRGBO(97, 97, 97, 1),
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (currentValue / maxValue).clamp(0.0, 1.0);
    if (currentValue == 0 && maxValue == 0 && percentage == 1) {
      percentage = 0;
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            // width: percentage * MediaQuery.of(context).size.width,
            width: percentage * width,
            decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(10)),
          ),
          if (showPercentText) _percentText(percentage),
        ],
      ),
    );
  }

  Widget _percentText(double percentage) {
    percentage = percentage * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${percentage.toStringAsFixed(1)}%",
            style: TextStyle(color: Utils.getContrastingTextColor(percentage < 25 ? backgroundColor : progressColor, Utils.darkColorSecond, Utils.lightColorSecond), fontWeight: FontWeight.bold),
          ),
          Text(
            "${(percentage != 0 ? 100 - percentage : 0).toStringAsFixed(1)}%",
            style: TextStyle(color: Utils.getContrastingTextColor(percentage > 75 ? progressColor : backgroundColor, Utils.darkColorSecond, Utils.lightColorSecond), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
