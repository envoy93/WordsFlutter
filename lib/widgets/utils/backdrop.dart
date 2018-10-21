import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class BackDropWidgetState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  BackDropModel _model = BackDropModel(isFront: true);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) _model.toggle();
      print(status);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @protected
  Widget get title;

  @protected
  Widget get frontTitle => null;

  @protected
  Widget get backpanel;

  @protected
  Widget get body;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<BackDropModel>(
      model: _model,
      child: BackdropScaffold(
        headerHeight: 0.0,
        backLayer: backpanel,
        title: ScopedModelDescendant<BackDropModel>(
          rebuildOnChange: true,
          builder: (c, w, m) => m.isFront ? (frontTitle ?? title): title,
        ),
        frontLayer: body,
        frontLayerBorderRadius: BorderRadius.circular(Style.bigItemPadding),
        controller: _controller,
      ),
    );
  }
}

class _Model {
  bool isFront;
  _Model(this.isFront);
}

class BackDropModel extends Model {
  final _Model _model;
  BackDropModel({bool isFront = true}) : _model = _Model(isFront);

  bool get isFront => _model.isFront;

  void toggle() {
    _model.isFront = !_model.isFront;
    notifyListeners();
  }
}
