import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/page_top_categories.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenPageState();
  }
}

class SplashScreenPageState
    extends PreloadedState<SplashScreenPage, DatabaseClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SimpleFutureBuilder2<DatabaseClient>(
            snapshot: state,
            onError: "Ошибка в сплеше",
            builder: (_, DatabaseClient data) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new TopCategoriesPage(data,
                            data.categoriesProvider.forTopLevel(), 0)));
              });
              return SizedBox();
            }));
  }

  @override
  Future<DatabaseClient> onLoad() async {
    DatabaseClient databaseClient = new DatabaseClient();
    await new Future.delayed(new Duration(seconds: 3));
    await databaseClient.create();
    return databaseClient;
  }
}
