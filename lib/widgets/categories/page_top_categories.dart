import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_categories.dart';
import 'package:hello_world/widgets/drawer.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class TopCategoriesPage extends StatefulWidget {
  TopCategoriesPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TopCategoriesPageState<TopCategoriesPage>();
  }
}

class TopCategoriesPageState<T extends StatefulWidget> extends State<T> {
  int _currentIndex = 0;
  Future<List<Category>> state;

  TopCategoriesPageState();

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
        decoration: new BoxDecoration(color: Theme.of(context).backgroundColor),
        child: SimpleFutureBuilder<List<Category>>(
            onReload: () {
              setState(() {
                state = null;
              });
            },
            future: state ?? (state = onLoad()),
            builder: (context, List<Category> data) => Scaffold(
              drawer: NavigationDrawer(),
                  appBar: AppBar(title: selector(data)),
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: list(data[_currentIndex]))
                      ]),
                )));
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
