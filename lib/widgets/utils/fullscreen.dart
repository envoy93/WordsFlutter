import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hello_world/main.dart';

abstract class ActiveState<T extends StatefulWidget> extends State<T> {
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
}

abstract class PreloadedState<T extends StatefulWidget, Y> extends State<T> {
  bool _isInitState = true;
  @protected
  bool get isInitState => _isInitState;
  @protected
  AsyncSnapshot<Y> state = AsyncSnapshot<Y>.nothing();

  @override
  void initState() {
    super.initState();
    _isInitState = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitState) {
      onReload();
    }
  }

  void onReload() async {
    setState(() {
      state = AsyncSnapshot.withData(ConnectionState.waiting, null);
    });

    Y y;
    try {
      y = await onLoad();
    } catch (e) {
      setState(() {
        state = AsyncSnapshot.withError(ConnectionState.done, e.toString());
      });
      return;
    }

    setState(() {
      state = AsyncSnapshot.withData(ConnectionState.done, y);
    });

    _isInitState = false;
  }

  @protected
  Future<Y> onLoad();
}

class SimpleSnapshotBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget loading;
  final Color color;
  final String onError;
  final Function(BuildContext, T) builder;
  final Function onReload;

  SimpleSnapshotBuilder({
    Key key,
    @required this.snapshot,
    @required this.builder,
    this.onError = W.error,
    this.color = Colors.white,
    this.onReload,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return loading ?? LoadingWidget(color: color);
      default:
        if (snapshot.hasError) {
          return TextReloadWidget(
            snapshot.error, //onError,
            color: color,
            onReload: onReload,
          );
        } else {
          return builder(context, snapshot.data);
        }
    }
  }
}

class SimpleFutureBuilder<T> extends FutureBuilder<T> {
  final Function onReload;

  SimpleFutureBuilder({
    Key key,
    @required future,
    @required builder,
    String onError = W.error,
    Color color = Colors.white,
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
}

class LoadingWidget extends FullScreenWidget {
  final Color color;

  LoadingWidget({this.color = Colors.white});

  @override
  Widget child(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      width: Style.bigItemPadding * 2,
      height: Style.bigItemPadding * 2,
    );
  }
}

class TextWidget extends FullScreenWidget {
  final String text;
  final Color color;

  TextWidget(this.text, {this.color = Colors.white});

  @override
  Widget child(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.title.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}

class TextReloadWidget extends FullScreenWidget {
  final String text;
  final Color color;
  final Function onReload;

  TextReloadWidget(this.text, {this.color = Colors.white, this.onReload});

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
        SizedBox(height: Style.itemPadding),
        RaisedButton(
          shape: Style.shape,
          padding: Style.padding,
          color: Style.offBG,
          onPressed: onReload,
          child: Text(
            W.reload,
            style: Theme.of(context).textTheme.title.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

abstract class FullScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Style.bigItemPadding),
            child: child(context),
          ),
        ))
      ],
    );
  }

  Widget child(BuildContext context);
}
