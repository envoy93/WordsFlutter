import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/providers/db/db.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class SplashScreenPage extends StatefulWidget {
  final DatabaseConnection _conn;

  SplashScreenPage(this._conn, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SplashScreenPageState();
  }
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Future<bool> _state;

  Future<bool> _onLoad() async {

    await new Future.delayed(new Duration(seconds: 3));
    print('splash start');
    await widget._conn.db;
    print('splash finish');
    return true;
  }

  @override
  void initState() {
    super.initState();
    _state = _onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _state,
        builder: (_, data) {
          return ReloadWidget<bool>(
            snapshot: data,
            onLoading: LoadingWidget(
              color: Colors.black,
            ),
            onError: (error) => TextReloadWidget(
                  text: (error != null) ? error.toString() : W.error,
                  color: Colors.black,
                  onReload: () {},
                ),
            onData: (_) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(
                    context, AppRoute.categories(topCategory: 0));
              });
              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
