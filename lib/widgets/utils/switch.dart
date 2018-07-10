import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';

class TwoSwitch extends StatelessWidget {
  final Widget first;
  final Widget second;
  final bool isFirst;
  final TwoSwitchTapCallback onTap;
  TwoSwitch(
      {this.first = const SizedBox(),
      this.second = const SizedBox(),
      this.isFirst = true,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    var shape = BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(Style.itemPadding));
    var padding = const EdgeInsets.all(Style.itemPadding);
    return !isFirst
        ? RaisedButton(
            elevation: Style.itemPadding,
            padding: padding,
            shape: shape,
            child: second,
            onPressed: onTap,
          )
        : FlatButton(
            padding: padding,
            shape: shape,
            child: first,
            onPressed: onTap,
          );
  }
}

typedef void TwoSwitchTapCallback();
