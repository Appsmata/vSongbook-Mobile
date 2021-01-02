import 'package:flutter/material.dart';
import 'package:vsongbook/utils/colors.dart';

class AsNotice extends StatefulWidget {
  Color backgroundColor;
  Color color;
  Color containerColor;
  double borderRadius;
  String text;
  AsNoticeState noticeState;

  AsNotice(
    {
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10,
      this.text
    }
  );

  @override
  createState() => noticeState = AsNoticeState(
      backgroundColor: this.backgroundColor,
      color: this.color,
      containerColor: this.containerColor,
      borderRadius: this.borderRadius,
      text: this.text);

  void hideWidget() {
    noticeState.hideWidget();
  }

  void showWidget() {
    noticeState.showWidget();
  }

  void showWidgetWithText(String title) {
    noticeState.showWidgetWithText(title);
  }

  static Widget getNotice(String title) {
    return AsNotice(
      backgroundColor: Colors.black12,
      color: Colors.black,
      containerColor: Colors.white,
      borderRadius: 5,
      text: title,
    );
  }
}

class AsNoticeState extends State<AsNotice> {
  Color backgroundColor;
  Color color;
  Color containerColor;
  double borderRadius;
  String text;
  bool _opacity = false;

  AsNoticeState(    
    {
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10,
      this.text
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_opacity ? null : Opacity(
        opacity: _opacity ? 1 : 0,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 300,
                height: 350,
                decoration: BoxDecoration(
                  color: containerColor,
                  border: Border.all(color: ColorUtils.primaryColor),
                  boxShadow: [BoxShadow(blurRadius: 5)],
                  borderRadius: BorderRadius.all(
                     Radius.circular(borderRadius)
                  )
                ),
              ),
            ),
            Center(
              child: _getCenterContent(),
            )
          ],
        ),
      )
    );
  }

  Widget _getCenterContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: ColorUtils.primaryColor, size: 200),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: 300,
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 25),
            ),
          )
        ],
      ),
    );
  }

  void hideWidget() {
    setState(() {
      _opacity = false;
    });
  }

  void showWidget() {
    setState(() {
      _opacity = true;
    });
  }

  void showWidgetWithText(String title) {
    setState(() {
      _opacity = true;
      text = title;
    });
  }
}
