import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_words.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/switch.dart';
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
    return _CategoriesPageState(categories[initial]);
  }
}

class _CategoriesPageState extends ActiveState<CategoriesPage> {
  final scrollController = new ScrollController();
  PageController pageController;
  final _config = CategoryModel();
  Category _current;

  _CategoriesPageState(this._current);

  Future<bool> _onCategorySaved(Category data, BuildContext context) async {
    final provider = Providers.of(context).categories;
    await new Future.delayed(new Duration(seconds: 1));
    if (!await provider.changeSave(data)) {
      // error
      return false;
    } else if (isActive) {
      setState(() {});
    }
    return true;
  }

  @override
  void dispose() {
    pageController?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (pageController == null)
      pageController =
          PageController(initialPage: widget.initial, keepPage: true);

    final body = Container(
      color: theme.primaryColor,
      child: Container(
        padding: EdgeInsets.only(
            top: Style.itemPadding,
            left: Style.itemPadding,
            right: Style.itemPadding),
        decoration: BoxDecoration(
            color: theme.canvasColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Style.bigItemPadding),
            )),
        child: PageView.builder(
          onPageChanged: (i) {
            setState(() {
              _current = widget.categories[i];
            });
          },
          controller: pageController,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) => Column(
                children: <Widget>[
                  _categoryCard(widget.categories[index]),
                ],
              ),
        ),
      ),
    );

    final view = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Style.itemPadding),
          child: SingleChildScrollView(
            child: Text(
              _current.title,
              style: theme.textTheme.title.copyWith(
                  color: _current.isSaved ? Colors.white : Style.offBG),
            ),
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            primary: true,
          ),
        ),
        titleSpacing: 0.0,
        elevation: 0.0,
      ),
      backgroundColor: theme.canvasColor,
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ScopedModelDescendant<CategoryModel>(
        rebuildOnChange: true,
        builder: (context, _, model) => FloatingActionButton(
              backgroundColor: Colors.orangeAccent[200],
              mini: true,
              child: Icon(
                  model.isShowTranslate ? Icons.short_text : Icons.subject),
              isExtended: false,
              shape: const CircleBorder(),
              onPressed: model.onChangeTranslate,
            ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(
                  0.0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
          ],
        ),
      ),
    );

    return ScopedModel(
      model: _config,
      child: view,
    );
  }

  Widget _categoryCard(Category data) {
    return Expanded(
      child: Container(
        color: Theme.of(context).canvasColor,
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          children: [
            WordsList(key:Key("cc-wcl${data.id}"),category: data), 
            _footer(data),
          ],
          padding: const EdgeInsets.only(bottom: Style.bigItemPadding),
        ),
      ),
    );
  }

  Widget _footer(Category data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(Style.bigItemPadding),
          child: Theme(
            data: Theme.of(context).copyWith(buttonColor: Style.offBG),
            child: TwoSwitch(
              first: _savedButton(true),
              second: _savedButton(false),
              onError: WE.savedCategory,
              isFirst: data.isSaved,
              onTap: (context) async {
                return _onCategorySaved(data, context);
              },
            ),
          ),
        )
      ],
    );
  }
}

Widget _savedButton(bool isSaved) {
  return Row(
    children: <Widget>[
      Icon(isSaved ? Icons.star : Icons.star_border),
      SizedBox(width: Style.smallPadding),
      Text((isSaved ? W.savedCategory : W.unsavedCategory).toUpperCase())
    ],
  );
}

class CategoryConfig {
  bool showTranslate;
  CategoryConfig({this.showTranslate = false}); //TODO
}

class CategoryModel extends Model {
  CategoryConfig config = new CategoryConfig();

  bool get isShowTranslate => config.showTranslate;

  void onChangeTranslate() {
    config.showTranslate = !config.showTranslate;
    notifyListeners();
  }
}
