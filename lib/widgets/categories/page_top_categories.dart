import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/utils/backdrop.dart';
import 'package:hello_world/providers/blocs/top_category_bloc.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:scoped_model/scoped_model.dart';

class TopCategoriesPage extends StatefulWidget {
  final int initialData;

  TopCategoriesPage({this.initialData: -1, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      new TopCategoriesPageState(initialData);
}

class TopCategoriesPageState<T extends StatefulWidget> extends State<T> {
  final int _initialData;
  TopCategoryBloc _bloc;

  TopCategoriesPageState(this._initialData);

  @override
  void didChangeDependencies() {
    _bloc = TopCategoryBloc(
      categoriesProvider: Providers.of(context).categories,
      preferencesProvider: Providers.of(context).preferences,
    );
    
    _bloc.fetchTopCategories();
    if (_initialData >= 0) _bloc.selectTopCategory(_initialData);
    super.didChangeDependencies();
  }

@override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TopCategoryBlocProvider(
      bloc: _bloc,
      child: new Container(
          color: Theme.of(context).primaryColor,
          child: StreamBuilder<List<Category>>(
            stream: _bloc.topCategories,
            builder: (context, data) {
              if (!data.hasData) return LoadingWidget(color: Colors.black);
              return content(data.data);
            },
          )),
    );
  }

  @protected
  Widget content(List<Category> data) => TopCategories(topCategories: data);
}

class TopCategories extends StatefulWidget {
  final List<Category> topCategories;

  TopCategories({
    @required this.topCategories,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TopCategoriesState();
  }
}

class TopCategoriesState extends BackDropWidgetState<TopCategories> {
  AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return super.build(context);
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
  Widget get body {
    final bloc = TopCategoryBlocProvider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: StreamBuilder<int>(
              stream: bloc.topCategory,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LoadingWidget(color: Colors.black);
                return list(widget.topCategories[snapshot.data]);
              }),
        ),
      ],
    );
  }

  @protected
  Widget list(Category data) =>
      CategoriesList(key: Key("ptc-cl${data.id}"), topCategory: data);

  @protected
  Widget selector() {
    final theme = Theme.of(context);
    final bloc = TopCategoryBlocProvider.of(context);
    return StreamBuilder<int>(
      stream: bloc.topCategory,
      builder: (_, snapshot) {
        if (!snapshot.hasData) return LoadingWidget(color: Colors.black);
        int i = 0;
        return DropdownButtonHideUnderline(
          child: Theme(
            data: theme.copyWith(canvasColor: theme.primaryColor),
            child: new DropdownButton<int>(
              value: snapshot.data,
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
                bloc.selectTopCategory(widget.topCategories[index].id);
              },
            ),
          ),
        );
      },
    );
  }
}
