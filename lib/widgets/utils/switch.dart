import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/main.dart';

typedef Future<bool> OnSwitchCallback(BuildContext context);

class CallbackSwitch extends StatefulWidget {
  final OnSwitchCallback onSwitch;
  final bool initialData;
  final Widget first;
  final Widget second;

  CallbackSwitch({
    @required this.onSwitch,
    @required this.initialData,
    @required this.first,
    @required this.second,
  });

  @override
  _CallbackSwitchState createState() => new _CallbackSwitchState(initialData);
}

class _CallbackSwitchState extends State<CallbackSwitch> {
  Future<bool> _state;
  bool _previous;

  _CallbackSwitchState(this._previous) {
    _state = Future.value(_previous);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      initialData: widget.initialData,
      future: _state,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _onLoading();
          default:
            if (!snapshot.hasData) {
              _state = Future.value(_previous); // reset
              return _onData(_previous);
            } else {
              return _onData(snapshot.data);
            }
        }
      });

  Widget _onLoading() => CircularProgressIndicator(); //TODO UI

  Widget _onData(bool isFirst) => InkWell(
        onTap: () {
          setState(() {
            _previous = isFirst;
            _state = widget.onSwitch(context);
          });
        },
        child: (isFirst) ? widget.first : widget.second,
      );
}

/*
Text(W.savedCategory.toUpperCase(),
          style: theme.title.copyWith(color: Colors.black))
 */
class PassiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color textColor;
  final String text;
  final hasIcon;

  PassiveButton({
    this.onPressed,
    @required this.textColor,
    @required this.text,
    this.hasIcon: true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final child = Text(text,
        style: theme.title.copyWith(
          color: textColor,
        ));
    return hasIcon
        ? FlatButton.icon(
            color: Colors.transparent,
            padding: AppDimensions.padding,
            shape: AppDimensions.shape,
            icon: Icon(
              Icons.star,
              color: textColor,
            ),
            label: child,
            onPressed: onPressed ?? () {},
          )
        : FlatButton(
            color: Colors.transparent,
            padding: AppDimensions.padding,
            shape: AppDimensions.shape,
            child: child,
            onPressed: onPressed ?? () {},
          );
  }
}

/*
Text(W.unsavedCategory.toUpperCase(),
                style: theme.title.copyWith(color: Colors.white))
 */
class ActiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color textColor;
  final String text;
  final hasIcon;

  ActiveButton({
    this.onPressed,
    @required this.textColor,
    @required this.text,
    this.hasIcon: true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final child = Text(text,
        style: theme.title.copyWith(
          color: textColor,
        ));
    return hasIcon
        ? RaisedButton.icon(
            color: Style.onBG,
            elevation: AppDimensions.itemPadding,
            shape: AppDimensions.shape,
            icon: Icon(
              Icons.star_border,
              color: textColor,
            ),
            label: child,
            onPressed: onPressed ?? () {})
        : RaisedButton(
            color: Style.onBG,
            elevation: AppDimensions.itemPadding,
            shape: AppDimensions.shape,
            child: child,
            onPressed: onPressed ?? () {});
  }
}
