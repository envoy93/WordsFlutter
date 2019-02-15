import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/widgets/utils/switch.dart';
import 'package:hello_world/main.dart';

/*abstract class ActiveState<T extends StatefulWidget> extends State<T> {
  Object _activeCallbackIdentity;
  bool _isInit = false;

  bool get isActive => (_activeCallbackIdentity != null);
  bool get isInit => _isInit;

  @override
  void initState() {
    subscribe();
    _isInit = true;
    super.initState();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    _isInit = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }

  @protected
  void unsubscribe() {
    _activeCallbackIdentity = null;
  }

  @protected
  void subscribe() {
    _activeCallbackIdentity = Object;
  }
}*/

/*class SimpleFutureBuilder<T> extends FutureBuilder<T> {
  final Function onReload;

  SimpleFutureBuilder({
    Key key,
    @required future,
    @required builder,
    String onError = W.error,
    Color color = Colors.black,
    this.onReload,
    Widget loading,
    T initialData,
  }) : super(
          key: key,
          initialData: initialData,
          future: future,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return loading ?? LoadingWidget(color: color);
              default:
                if (snapshot.hasError) {
                  return TextReloadWidget(
                    snapshot.error.toString(), //onError,
                    color: color,
                    onReload: onReload,
                  );
                } else {
                  return builder(context, snapshot.data);
                }
            }
          },
        );
}*/

class ReloadWidget<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget onLoading;
  final Widget Function(T) onData;
  final Widget Function(Object) onError;

  ReloadWidget(
      {Key key,
      @required this.snapshot,
      @required this.onLoading,
      @required this.onData,
      this.onError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return onLoading;
      default:
        if ((onError != null) && !snapshot.hasData) {
          return onError(snapshot.error);
        } else {
          return onData(snapshot.data);
        }
    }
  }
}

class LoadingWidget extends FullScreenWidget {
  final Color color;

  LoadingWidget({Key key, this.color = Colors.white}) : super(key: key);

  @override
  Widget child(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      size: AppDimensions.bigItemPadding * 2,
    );
  }
}

/*class TextWidget extends FullScreenWidget {
  final String text;
  final Color color;

  TextWidget(this.text, {Key key, this.color = Colors.white}) : super(key: key);

  @override
  Widget child(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.title.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}*/

class TextReloadWidget extends FullScreenWidget {
  final String text;
  final Color color;
  final Function onReload;

  TextReloadWidget({
    @required this.text,
    Key key,
    this.color = Colors.white,
    this.onReload,
  }) : super(key: key);

  @override
  Widget child(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: Theme.of(context).textTheme.title.copyWith(color: color),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.itemPadding),
        (onReload != null)
            ? ActiveButton(
                textColor: Colors.white,
                text: W.reload.toUpperCase(),
                hasIcon: false,
                onPressed: onReload,
              )
            : SizedBox(),
      ],
    );
  }
}

abstract class FullScreenWidget extends StatelessWidget {
  FullScreenWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.bigItemPadding),
            child: child(context),
          ),
        ))
      ],
    );
  }

  Widget child(BuildContext context);
}
