import 'package:flutter/material.dart';
import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/words_provider.dart';
import 'package:hello_world/providers/preferences_provider.dart';
import 'package:hello_world/providers/blocs/app_bloc.dart';

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
  final ICategoriesProvider _categories;
  final IWordsProvider _words;
  final IPreferencesProvider _preferences;

  Providers(
    this._categories,
    this._words,
    this._preferences, {
    @required this.child,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

class StateContainerState extends State<Providers> {
  ICategoriesProvider get categories => widget._categories;
  IWordsProvider get words => widget._words;
  IPreferencesProvider get preferences => widget._preferences;
  //AppBloc _bloc;

  StateContainerState() {
    //_bloc = ;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: AppBlocProvider(
        bloc: AppBloc(preferences),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    // TODO dispose db
  //  _bloc.dispose();
    super.dispose();
  }
}
