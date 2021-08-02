import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/// A custom line progress indicator widget with percentage
class AsLineProgress extends StatefulWidget {
  /// progress value of the linear percentindicator
  int progress;

  /// Color of the border for the widget
  Color borderColor;

  /// Progress Color of the indicator
  Color progressColor;

  /// Background Color for the widget
  Color backgroundColor;

  AsLineProgressState widgetState;

  AsLineProgress(
      {this.progress,
      this.borderColor,
      this.progressColor,
      this.backgroundColor});

  @override
  createState() => widgetState = new AsLineProgressState(
      progress: this.progress,
      borderColor: this.borderColor,
      progressColor: this.progressColor,
      backgroundColor: this.backgroundColor);

  /// initial setting up of the widget
  static Widget setUp(int progress, Color borderColor, Color progressColor,
      Color backgroundColor) {
    return new AsLineProgress(
      progress: progress,
      borderColor: borderColor,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
    );
  }

  /// change progress with a new value
  void setProgress(int newProgress) {
    widgetState.setNewProgress(newProgress);
  }

  /// change the outlook of the widgeton the fly
  void modify(Color borderColor, Color progressColor, Color backgroundColor) {
    widgetState.modifyWidget(borderColor, progressColor, backgroundColor);
  }
}

class AsLineProgressState extends State<AsLineProgress> {
  int progress;
  Color borderColor;
  Color progressColor;
  Color backgroundColor;

  AsLineProgressState(
      {this.progress,
      this.borderColor,
      this.progressColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(blurRadius: 3)],
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Stack(
        children: <Widget>[
          LinearPercentIndicator(
            percent: double.parse((progress / 100).toStringAsFixed(1)),
            lineHeight: 35,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
            linearStrokeCap: LinearStrokeCap.round,
            padding: const EdgeInsets.only(left: 18, right: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Text(
                progress.toString() + " %",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// change progress
  void setNewProgress(int newProgress) {
    setState(() {
      progress = newProgress;
    });
  }

  void modifyWidget(
      Color borderColor, Color progressColor, Color backgroundColor) {
    setState(() {
      borderColor = borderColor;
      progressColor = progressColor;
      backgroundColor = backgroundColor;
    });
  }
}
