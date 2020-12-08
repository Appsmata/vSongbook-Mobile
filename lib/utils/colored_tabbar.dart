import 'package:flutter/material.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  final Color color;
  final TabBar tabBar;

  ColoredTabBar({Key key, @required this.color, @required this.tabBar}) : super(key: key);

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Material(elevation: 4.0, color: color, child: tabBar);
}