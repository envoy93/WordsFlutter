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
                padding: EdgeInsets.all(Style.bigItemPadding),
                children:
                    data.map((c) => _top2category(c, false, context)).toList(),
              ),
            ));
  }

  Widget _top2category(Category data, bool isExpanded, BuildContext context) {
    var theme = Theme.of(context);
    var saved = data.childs.where((c) => c.isSaved).length;
    var all = data.childs.length;

    var icon = (all == saved)
        ? Icon(Icons.check, color: Style.grey)
        : Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffcccccc), blurRadius: Style.itemPadding)
                ]),
            padding: EdgeInsets.all(Style.itemPadding / 2),
            width: Style.itemPadding * 3,
            height: Style.itemPadding * 3,
            child: CircleProgress(
              (all == 0) ? 1.0 : saved / all,
              completeColor: Style.offBG,
              color: Style.offBG,
              lineWidth: Style.smallPadding / 1.5,
              style: PainterStyle.Clock,
            ),
          );

    var item = ListTile(
      dense: true,
      isThreeLine: false,
      leading: icon,
      subtitle: Text("${W.savedCategory} $saved/$all",
          style: theme.textTheme.subhead),
      title: Text(
        data.title,
        textAlign: TextAlign.start,
        style: theme.textTheme.title,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: Style.smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Style.itemPadding),
        color: Colors.white,
      ),
      child: ExpansionTile(
        //backgroundColor: Colors.red,
        trailing: SizedBox(),
        title: item,
        initiallyExpanded: isExpanded,
        children: <Widget>[
          CategoryChilds(
            categories: data.childs,
          ),
        ],
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
                    margin:
                        EdgeInsets.symmetric(horizontal: Style.smallPadding),
                    child: Chip(
                      backgroundColor: c.isSaved ? Style.onBG : Style.offBG,
                      labelStyle: theme.textTheme.caption.copyWith(
                          color: c.isSaved ? Style.grey : Colors.white),
                      label: Text(c.title),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
