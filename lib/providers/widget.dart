import 'package:flutter/material.dart';
import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/providers/words_provider.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class Providers extends StatefulWidget {
  final Widget child;
  final DatabaseClient dbClient;

  Providers({
    @required this.child,
    @required this.dbClient,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState(dbClient);
}

class StateContainerState extends State<Providers> {
  DatabaseClient _dbClient;

  CategoriesProvider get categories => _dbClient.categoriesProvider;
  WordsProvider get words => _dbClient.wordsProvider;
  DatabaseClient get db => _dbClient;

  StateContainerState(this._dbClient);

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}