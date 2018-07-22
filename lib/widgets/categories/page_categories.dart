import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/category.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/page_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesPage extends StatefulWidget {
  final int initial;
  final List<Category> categories;

  CategoriesPage({
    Key key,
    @required this.categories,
    @required this.initial,
  })  : assert((initial < categories.length) && (initial >= 0)),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPageState(initial);
  }
}

class _CategoriesPageState extends ActiveState<CategoriesPage> {
  ScrollController scrollController;
  PageController pageController;
  Future<CategoryModel> _config;
  int _current;

  _CategoriesPageState(this._current);

  Future<CategoryModel> onLoad() async {
    var provider = Providers.of(context).words;
    await Future.delayed(Duration(seconds: 1));
    return CategoryModel(await provider.isFullList());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pageController == null)
      pageController = PageController(initialPage: _current, keepPage: true);

    final indicator = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Style.itemPadding, vertical: Style.smallPadding),
        child: RectangleIndicator(
          pageController,
          widget.categories.length,
          Style.itemPadding / 2,
          Color(0xffcccccc),
          Style.grey,
          initialPage: _current,
        ),
      ),
    );

    final body = Stack(
      children: <Widget>[
        indicator,
        Container(
          margin: const EdgeInsets.only(bottom: Style.bigItemPadding),
          child: PageView.builder(
            onPageChanged: (i) {
              _current = i;
            },
            controller: pageController,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) => CategoryCard(
                  widget.categories[index],
                  key: Key("pc-c${widget.categories[index]}"),
                ),
          ),
        ),
      ],
    );

    final button = ScopedModelDescendant<CategoryModel>(
      rebuildOnChange: true,
      builder: (context, _, model) => FloatingActionButton(
            mini: true,
            child:
                Icon(model.isShowTranslate ? Icons.short_text : Icons.subject),
            isExtended: false,
            shape: const CircleBorder(),
            onPressed: () {
              model.onChangeTranslate(() {
                Providers
                    .of(context)
                    .words
                    .setIsFullList(model.isShowTranslate);
              });
            },
          ),
    );

    final view = Scaffold(
      backgroundColor: Style.lightGrey,
      appBar: AppBar(
        backgroundColor: Style.lightGrey,
        elevation: 0.0,
      ),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: button,
    );

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SimpleFutureBuilder<CategoryModel>(
        onReload: () {
          setState(() {
            _config = null;
          });
        },
        future: _config ?? (_config = onLoad()),
        builder: (context, CategoryModel data) => ScopedModel(
              model: data,
              child: view,
            ),
      ),
    );
  }
}

class CategoryConfig {
  bool showTranslate;
  CategoryConfig(this.showTranslate); //TODO
}

class CategoryModel extends Model {
  final CategoryConfig config;

  CategoryModel(showTranslate)
      : config = CategoryConfig(showTranslate ?? true);

  bool get isShowTranslate => config.showTranslate;

  void onChangeTranslate(VoidCallback callback) {
    config.showTranslate = !config.showTranslate;
    notifyListeners();
    callback();
  }
}
