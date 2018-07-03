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
    return RaisedButton(
      elevation: Style.itemPadding,
      padding: EdgeInsets.all(Style.itemPadding),
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(Style.itemPadding)),
      child: isFirst ? first : second,
      onPressed: onTap,
    );
  }
}

typedef void TwoSwitchTapCallback();
