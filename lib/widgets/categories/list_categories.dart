import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/page_categories.dart';
import 'package:hello_world/widgets/utils/circleProgress.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class CategoriesList extends StatefulWidget {
  final Category topCategory;

  CategoriesList({Key key, @required this.topCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesListState();
  }
}

class _CategoriesListState extends State<CategoriesList> {
  Future<List<Category>> _state;
  int _expanded = -100;

  Future<List<Category>> onLoad() async {
    var provider = Providers.of(context).categories;
    await Future.delayed(Duration(seconds: 1));
    return await provider.forParentRecursive(widget.topCategory.id);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFutureBuilder<List<Category>>(
        onReload: () {
          setState(() {
            _state = null;
          });
        },
        future: _state ?? (_state = onLoad()),
        builder: (_, List<Category> data) => Scrollbar(
              child: ListView(
                children: data
                    .map(
                      (c) => ExpansionTile(
                            trailing: SizedBox(),
                            onExpansionChanged: (expanded) => setState(() {
                                  _expanded = (_expanded == -100) ? c.id : -100;
                                }),
                            title: _top2category(c, c.id == _expanded, context),
                            initiallyExpanded: c.id == _expanded,
                            children: <Widget>[
                              CategoryChilds(
                                categories: c.childs,
                              ),
                            ],
                          ),
                    )
                    .toList(),
              ),
            ));
  }

  Widget _top2category(Category data, bool isExpanded, BuildContext context) {
    var theme = Theme.of(context);
    var saved = data.childs.where((c) => c.isSaved).length;
    var all = data.childs.length;
    return ListTile(
      isThreeLine: false,
      leading: Container(
          width: Style.bigItemPadding,
          height: Style.bigItemPadding,
          child: (all == saved)
              ? Icon(Icons.check, color: Style.grey)
              : CircleProgress(
                  (all == 0) ? 1.0 : saved / all,
                  completeColor: Style.grey, //Color(0xff4ca350),
                  color: theme.accentColor, //theme.primaryColor,
                  lineWidth: Style.smallPadding / 1.5,
                  style: PainterStyle.Clock,
                )),
      subtitle: Text("${W.savedCategory} $saved/$all",
          style: theme.textTheme.subhead.copyWith(color: Style.grey)),
      //dense: true,
      title: Text(
        data.title,
        textAlign: TextAlign.start,
        style: theme.textTheme.title,
      ),
    );
  }
}

class CategoryChilds extends StatefulWidget {
  final List<Category> categories;

  CategoryChilds({Key key, @required this.categories}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryChildsState(categories);
  }
}

class _CategoryChildsState extends State<CategoryChilds> {
  final List<Category> _categories;

  _CategoryChildsState(this._categories);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Style.itemPadding),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories
            .map((c) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (__) => new CategoriesPage(
                                  categories: _categories,
                                  initial: _categories.indexOf(c),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Style.itemPadding),
                    child: Chip(
                      backgroundColor: c.isSaved ? Style.onBG : Style.offBG,
                      labelStyle: theme.textTheme.caption,
                      label: Text(c.title),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
