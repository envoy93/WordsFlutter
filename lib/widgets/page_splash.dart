import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SplashScreenPageState();
  }
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Future _state;

  Future onLoad() async {
    var db = Providers.of(context).db;
    await new Future.delayed(new Duration(seconds: 3));
    if (!db.isInit) await db.create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SimpleFutureBuilder<void>(
        onReload: () {
          setState(() {
            _state = null;
          });
        },
        future: _state ?? (_state = onLoad()),
        builder: (_, void data) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) {
                return TopCategoriesPage();
              },
            ));
          });
          return SizedBox();
        },
      ),
    );
  }
}
