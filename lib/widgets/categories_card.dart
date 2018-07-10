import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/widgets/page_categories.dart';
import 'package:hello_world/widgets/utils/circleProgress.dart';

class CategoryChilds extends StatefulWidget {
  //final Category _topCategory;
  final List<Category> _categories;
  final DatabaseClient _dbClient;

  CategoryChilds(this._dbClient, this._categories);

  @override
  State<StatefulWidget> createState() {
    return _CategoryChildsState();
  }
}

class _CategoryChildsState extends State<CategoryChilds> {
  var rnd = Random(0);
  int _expanded = -100;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: widget._categories
            .map((c) => ExpansionTile(
                  trailing: SizedBox(),
                  onExpansionChanged: (expanded) => setState(() {
                        _expanded = expanded ? c.id : -100;
                      }),
                  title: _top2category(c, c.id == _expanded, context),
                  initiallyExpanded: c.id == _expanded,
                  children: <Widget>[_top3categories(c.childs, context)],
                ))
            .toList(),
      ),
    );
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
          child: CircleProgress(
            (all == 0) ? 1.0 : saved / all,
            completeColor: Color(0xff4ca350),
            color: theme.primaryColor,
            lineWidth: Style.itemPadding,
            style: PainterStyle.Line,
            /*child: Center(
                child: Text("99%",
                    style: theme.textTheme.caption.copyWith(fontSize: 15.0))),*/
          )),
      subtitle: Text("Выучено $saved/$all",
          style: theme.textTheme.subhead.copyWith(color: Style.grey)),
      //dense: true,
      title: Text(
        data.title,
        textAlign: TextAlign.start,
        style: theme.textTheme.title,
      ),
    );
  }

  Widget _top3categories(List<Category> data, BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(Style.itemPadding),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: data
            .map((c) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (__) => new CategoriesPage(
                                  widget._dbClient,
                                  data,
                                  data.indexOf(c),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Style.itemPadding),
                    child: Chip(
                      backgroundColor: c.isSaved ? Style.onBG : Style.offBG,
                      labelStyle: theme.textTheme.caption,
                      label: Text(
                        c.title.indexOf("/") > -1 //TODO
                            ? c.title.substring(0, c.title.indexOf("/"))
                            : c.title,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
