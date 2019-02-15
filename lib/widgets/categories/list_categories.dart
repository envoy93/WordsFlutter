import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/utils/circleProgress.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/providers/blocs/top_category_bloc.dart';

class CategoriesList extends StatefulWidget {
  final Category topCategory;

  CategoriesList({Key key, @required this.topCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesListState();
  }
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    final bloc = TopCategoryBlocProvider.of(context);
    return StreamBuilder<Map<int, Future<List<Category>>>>(
        stream: bloc.categories,
        builder: (_, data) {
          if (!data.hasData || (data.data[widget.topCategory.id] == null)) {
            return LoadingWidget(color: Colors.black);
          }

          var future = data.data[widget.topCategory.id];

          return FutureBuilder<List<Category>>(
            future: future,
            builder: (_, snapshot) {
              if (!snapshot.hasData) return LoadingWidget(color: Colors.black);

              return Scrollbar(
                  child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.bigItemPadding,
                    vertical: AppDimensions.smallPadding),
                children: snapshot.data
                    .map((c) => _top2category(c, false, context))
                    .toList(),
              ));
            },
          );
        });
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
                      color: Color(0xffcccccc), blurRadius: AppDimensions.itemPadding)
                ]),
            padding: EdgeInsets.all(AppDimensions.itemPadding / 2),
            width: AppDimensions.itemPadding * 3,
            height: AppDimensions.itemPadding * 3,
            child: CircleProgress(
              (all == 0) ? 1.0 : saved / all,
              completeColor: Style.offBG,
              color: Style.offBG,
              lineWidth: AppDimensions.smallPadding / 1.5,
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
      margin: EdgeInsets.symmetric(vertical: AppDimensions.smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.itemPadding),
        color: Colors.white,
      ),
      child: ExpansionTile(
        //backgroundColor: Colors.red,
        trailing: SizedBox(),
        title: item,
        initiallyExpanded: isExpanded,
        children: <Widget>[
          CategoryChilds(
            topCategory: data,
            categories: data.childs,
          ),
        ],
      ),
    );
  }
}

class CategoryChilds extends StatefulWidget {
  final List<Category> categories;
  final Category topCategory;

  CategoryChilds(
      {Key key, @required this.categories, @required this.topCategory})
      : super(key: key);

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
      padding: const EdgeInsets.all(AppDimensions.itemPadding),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories
            .map((c) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.category(
                        category: widget.topCategory.id,
                        subCategory: c.id,
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: AppDimensions.smallPadding),
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
