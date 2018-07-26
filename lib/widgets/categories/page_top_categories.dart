import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/utils/backdrop.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class TopCategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TopCategoriesPageState();
  }
}

class TopCategoriesPageState extends BackDropWidgetState<TopCategoriesPage> {
  AnimationController controller;

  @protected
  Widget get title => Text(W.categories);

  @protected
  Widget get backpanel => Menu(MenuItem.Categories, (item) {
        if (item == MenuItem.Categories) controller.fling(velocity: 1.0);
      });

  @protected
  Widget get body => TopCategories();
}

class TopCategories extends StatefulWidget {
  TopCategories({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TopCategoriesState<TopCategories>();
  }
}

class TopCategoriesState<T extends StatefulWidget> extends State<T> {
  int _currentIndex = 0;
  Future<List<Category>> state;

  TopCategoriesState();

  Future<List<Category>> onLoad() async {
    var provider = Providers.of(context).categories;

    await Future.delayed(Duration(seconds: 1));
    var topCategories = await provider.forLevel(0);
    int id = await provider.currentTopCategory();
    int index = topCategories.indexWhere((c) => c.id == id);
    _currentIndex = (index >= 0) ? index : 0;

    return topCategories;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Theme.of(context).backgroundColor,
        child: SimpleFutureBuilder<List<Category>>(
          onReload: () {
            setState(() {
              state = null;
            });
          },
          future: state ?? (state = onLoad()),
          builder: (context, List<Category> data) => Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  selector(data),
                  Expanded(child: list(data[_currentIndex])),
                ],
              ),
        ));
  }

  Widget list(Category topCategory) {
    return CategoriesList(
        key: Key("ptc-cl${topCategory.id}"), topCategory: topCategory);
  }

  @protected
  Widget selector(List<Category> data) {
    final theme = Theme.of(context);
    int i = 0;
    return DropdownButtonHideUnderline(
      child: Theme(
        data: theme.copyWith(canvasColor: theme.primaryColor),
        child: new DropdownButton<int>(
          value: _currentIndex,
          items: data
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
            saveTopCategory(data[index].id);
            if (_currentIndex != index) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  saveTopCategory(int id) async {
    Providers.of(context).categories.setCurrentTopCategory(id);
  }
}
