import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class TwoSwitch extends StatefulWidget {
  final Widget first;
  final Widget second;
  final bool isFirst;
  final String onError;
  final TwoSwitchTapCallback onTap;

  TwoSwitch({
    Key key,
    this.first = const SizedBox(),
    this.second = const SizedBox(),
    this.isFirst = true,
    this.onError = "",
    @required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TwoSwitchState(isFirst);
  }
}

class _TwoSwitchState extends ActiveState<TwoSwitch> {
  bool _isFirst;
  _TwoSwitchState(this._isFirst);

  @override
  Widget build(BuildContext context) {
    var listener = () async {
      if (await widget.onTap(context)) {
        _isFirst = !_isFirst;
        if (isActive) {
          setState(() {});
        }
      } else {
        if (widget.onError.isNotEmpty && isActive) {
          message(WE.savedWord, context);
        }
      }
    };
    return Container(
          child: _isFirst
          ? FlatButton(
              padding: Style.padding,
              shape: Style.shape,
              child: widget.first,
              onPressed: listener,
            )
          : RaisedButton(
              elevation: Style.itemPadding,
              padding: Style.padding,
              shape: Style.shape,
              child: widget.second,
              onPressed: listener,
            ),
    );
  }
}

typedef Future<bool> TwoSwitchTapCallback(BuildContext context);
