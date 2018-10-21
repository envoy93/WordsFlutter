import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/utils/backdrop.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:scoped_model/scoped_model.dart';

class TopCategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TopCategoriesPageState();
}

class TopCategoriesPageState<T extends StatefulWidget> extends State<T> {
  Future<List<Category>> state;
  int init = 0;

  Future<List<Category>> onLoad() async {
    var provider = Providers.of(context).categories;

    await Future.delayed(Duration(seconds: 1));
    var topCategories = await provider.forLevel(0);
    int id = await provider.currentTopCategory();
    int index = topCategories.indexWhere((c) => c.id == id);
    init = (index >= 0) ? index : 0;

    return topCategories;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Theme.of(context).primaryColor,
        child: SimpleFutureBuilder<List<Category>>(
          onReload: () {
            setState(() {
              state = null;
            });
          },
          future: state ?? (state = onLoad()),
          builder: (context, List<Category> data) => content(data, init),
        ));
  }

  @protected
  Widget content(List<Category> data, int init) => TopCategories(data, init);
}

class TopCategories extends StatefulWidget {
  final List<Category> topCategories;
  final int init;

  TopCategories(this.topCategories, this.init, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TopCategoriesState();
  }
}

class TopCategoriesState extends BackDropWidgetState<TopCategories> {
  AnimationController controller;
  TopCategoriesModel model;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: model ?? (model = TopCategoriesModel(widget.init)),
        child: super.build(context));
  }

  @protected
  Widget get title => Text(W.categories);

  @protected
  Widget get backpanel => Menu(MenuItem.Categories, (item) {
        if (item == MenuItem.Categories) controller.fling(velocity: 1.0);
      });

  @override
  Widget get frontTitle => selector();

  @protected
  Widget get body => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: ScopedModelDescendant<TopCategoriesModel>(
            rebuildOnChange: true,
            builder: (c, w, m) => list(widget.topCategories[m.current]),
          )),
        ],
      );

  @protected
  Widget list(Category data) {
    return CategoriesList(key: Key("ptc-cl${data.id}"), topCategory: data);
  }

  @protected
  Widget selector() {
    final theme = Theme.of(context);

    return ScopedModelDescendant<TopCategoriesModel>(
      rebuildOnChange: true,
      builder: (c, w, m) {
        int i = 0;
        return DropdownButtonHideUnderline(
          child: Theme(
            data: theme.copyWith(canvasColor: theme.primaryColor),
            child: new DropdownButton<int>(
              value: m.current,
              items: widget.topCategories
                  .map(
                    (c) => DropdownMenuItem<int>(
                          value: i++,
                          child: new Text(
                            c.title,
                            style: theme.textTheme.title,
                          ),
                        ),
                  )
                  .toList(),
              onChanged: (index) {
                saveTopCategory(widget.topCategories[index].id);
                if (m.current != index) m.current = index;
              },
            ),
          ),
        );
      },
    );
  }

  saveTopCategory(int id) async {
    Providers.of(context).categories.setCurrentTopCategory(id);
  }
}

class _Model {
  int current;
  _Model(this.current);
}

class TopCategoriesModel extends Model {
  final _Model _model;
  TopCategoriesModel(int current) : _model = _Model(current);

  set current(int index) {
    _model.current = index;
    notifyListeners();
  }

  get current => _model.current;
}
