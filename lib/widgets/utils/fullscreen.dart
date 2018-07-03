import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hello_world/main.dart';

abstract class PreloadedState<T extends StatefulWidget, Y> extends State<T> {
  AsyncSnapshot<Y> state = AsyncSnapshot<Y>.nothing();

  @override
  void initState() {
    super.initState();
    onReload();
  }

  void onReload() async {
    setState(() {
      state = AsyncSnapshot.withData(ConnectionState.waiting, null);
    });

    var y = await onLoad();

    setState(() {
      state = AsyncSnapshot.withData(ConnectionState.done, y);
    });
  }

  @protected
  Future<Y> onLoad();
}

class SimpleFutureBuilder2<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget loading;
  final Color color;
  final String onError;
  final Function(BuildContext, T) builder;

  SimpleFutureBuilder2(
      {@required this.snapshot,
      @required this.builder,
      this.onError = W.error,
      this.color = Colors.white,
      this.loading});

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return loading ?? LoadingWidget(color: color);
      default:
        if (snapshot.hasError || (snapshot.data == null)) {
          return TextWidget(
            onError,
            color: color,
          );
        } else {
          return builder(context, snapshot.data);
        }
    }
  }
}

class SimpleFutureBuilder<T> extends FutureBuilder<T> {
  SimpleFutureBuilder(
      {@required future,
      @required builder,
      String onError = "Произошла непредвиденная ошибка",
      Color color = Colors.white,
      Widget loading,
      T initialData})
      : super(
            initialData: initialData,
            future: future,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return loading ?? LoadingWidget(color: color);
                default:
                  if (snapshot.hasError || (snapshot.data == null)) {
                    return TextWidget(
                      onError,
                      color: color,
                    );
                  } else {
                    return builder(context, snapshot);
                  }
              }
            });
}

class LoadingWidget extends FullScreenWidget {
  final Color color;

  LoadingWidget({this.color = Colors.white});

  @override
  Widget child(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      width: 50.0,
      height: 50.0,
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

abstract class FullScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: child(context),
          ),
        ))
      ],
    );
  }

  Widget child(BuildContext context);
}
