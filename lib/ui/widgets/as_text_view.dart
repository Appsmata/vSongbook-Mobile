import 'package:flutter/material.dart';

/// Stateful TextView control
class AsTextView extends StatefulWidget {
  String text;
  double fsize;
  bool isbold;
  Color color;
  Color backgroundColor;

  AsTextViewState widgetState;

  AsTextView(
    {
      this.text,
      this.fsize,
      this.isbold,
      this.color,
      this.backgroundColor,
    }
  );

  @override
  createState() => widgetState = new AsTextViewState( 
    text: this.text,
    fsize: this.fsize,
    isbold: this.isbold,
    color: this.color 
  );

  /// initial setting up of the widget
  static Widget setUp(String setText, double setSize, bool setWeight, Color setColor, Color setBackgroundColor) {
    return new AsTextView(
      text: setText,
      fsize: setSize,
      isbold: setWeight,  
      color: setColor,
      backgroundColor: setBackgroundColor,
    );
  }
  
  /// change the text of the widgeton the fly
  void setText(String newtext) {
    widgetState.setNewText(newtext);
  }

  /// change the font size of the widgeton the fly
  void setSize(double newfontsize) {
    widgetState.setNewFontSize(newfontsize);
  }

  /// change the outlook of the widgeton the fly
  void modify(String newText, double newSize, bool newWeight, Color newColor, Color newBackgroundColor) {    
    widgetState.modifyWidget(newText, newSize, newWeight, newColor, newBackgroundColor);
  }
}

class AsTextViewState extends State<AsTextView> {
  String text;
  double fsize;
  bool isbold;
  Color color;
  Color backgroundColor;

  AsTextViewState( { this.text, this.fsize, this.isbold, this.color, this.backgroundColor } );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: isbold ? FontWeight.bold : FontWeight.normal, fontSize: fsize, color: color, backgroundColor: backgroundColor),
    );
  }

  void setNewText(String newText) {
    setState(() { text = newText; });
  }
  
  void setNewFontSize(double newFontsize) {
    setState(() { fsize = newFontsize; });
  }

  void modifyWidget(String setText, double setSize, bool setWeight, Color setColor, Color setBackgroundColor) {
    setState(() {
      text = setText;
      fsize = setSize;
      isbold = setWeight;
      color = setColor;
      backgroundColor = setBackgroundColor;
    });
  }

}
