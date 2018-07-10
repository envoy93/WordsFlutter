import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/widgets/categories_card.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class TopCategoriesPage extends StatefulWidget {
  final int _initial;
  final DatabaseClient _dbClient;
  final List<Category> _topCategories;

  TopCategoriesPage(this._dbClient, this._topCategories, this._initial);

  @override
  State<StatefulWidget> createState() {
    return new _TopCategoriesPageState(_topCategories[_initial]);
  }
}

class _TopCategoriesPageState
    extends PreloadedState<TopCategoriesPage, List<Category>> {
  Category _current;

  _TopCategoriesPageState(this._current);

  @override
  Future<List<Category>> onLoad() async {
    await Future.delayed(Duration(seconds: 1));
    return await widget._dbClient.categoriesProvider
        .forParentRecursive(_current.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: selector(context)),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Expanded(child: list(context))]),
    );
  }

  Widget selector(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: new DropdownButton<Category>(
        value: _current,
        items: widget._topCategories
            .map(
              (c) => DropdownMenuItem<Category>(
                  value: c,
                  child: new Text(c.title,
                      style: Theme.of(context).textTheme.title)),
            )
            .toList(),
        onChanged: (v) {
          _current = v;
          onReload();
        },
      ),
    );
  }

  Widget list(BuildContext context) {
    return SimpleFutureBuilder2(
        snapshot: state,
        builder: (_, data) => CategoryChilds(widget._dbClient, data));
  }
}
