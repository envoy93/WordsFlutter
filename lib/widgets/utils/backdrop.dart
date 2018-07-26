import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';

class BackDropWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BackDropWidgetState();
  }
}

class BackDropWidgetState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @protected
  Widget get title => SizedBox();

  @protected
  Widget get backpanel => SizedBox();

  @protected
  Widget get body => SizedBox();

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      headerHeight: 0.0,
      title: title,
      backpanel: backpanel,
      body: body,
      controller: controller,
    );
  }
}
