import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/providers/words_provider.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/switch.dart';
import 'package:hello_world/widgets/words_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriesPage extends StatefulWidget {
  final DatabaseClient _dbClient;
  final int _initial;
  final List<Category> _categories;

  CategoriesPage(this._dbClient, this._categories, this._initial);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPageState(_categories[_initial]);
  }
}

class _CategoriesPageState extends PreloadedState<CategoriesPage, List<Word>> {
  final scrollController = new ScrollController();
  final _config = CategoryModel();
  Category _current;

  _CategoriesPageState(this._current);

  @override
  Future<List<Word>> onLoad() async {
    await new Future.delayed(new Duration(seconds: 1));
    return await widget._dbClient.wordsProvider.forCategory(_current.id);
  }

  Future onCategorySaved(Category data) async {
    await new Future.delayed(new Duration(seconds: 1));
    await widget._dbClient.categoriesProvider.changeSave(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var view = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: null,
        title: Text(_current.title.toUpperCase()),
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          padding: EdgeInsets.only(
              top: Style.itemPadding,
              left: Style.itemPadding,
              right: Style.itemPadding),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Style.bigItemPadding),
                  topRight: Radius.circular(Style.bigItemPadding))),
          child: PageView.builder(
            onPageChanged: (i) {
              _current = widget._categories[i];
              onReload();
            },
            controller: PageController(initialPage: widget._initial),
            itemCount: widget._categories.length,
            itemBuilder: (context, index) => Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      _getCategoryCard(context),
                    ],
                  ),
                ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ScopedModelDescendant<CategoryModel>(
        rebuildOnChange: true,
        builder: (context, _, model) => FloatingActionButton(
              backgroundColor: Colors.orangeAccent[200],
              mini: true,
              child: Icon(
                  model.isShowTranslate ? Icons.short_text : Icons.subject),
              isExtended: false,
              shape: CircleBorder(),
              onPressed: model.onChangeTranslate,
            ),
      ),
      bottomNavigationBar: BottomAppBar(
        hasNotch: true,
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
            ]),
      ),
    );

    return ScopedModel(
      model: _config,
      child: view,
    );
  }

  Widget _getCategoryCard(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).canvasColor,
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          children: [
            SimpleFutureBuilder2<List<Word>>(
              snapshot: state,
              onError: "Ошибка в категории",
              builder: (_, words) {
                return WordsCard(words: words);
              },
            ),
            footer(context),
          ],
          padding: EdgeInsets.only(bottom: 30.0),
        ),
      ),
    );
  }

  Widget footer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(Style.bigItemPadding),
          child: Theme(
            data: Theme.of(context).copyWith(buttonColor: _current.isSaved? Style.onBG: Style.offBG),
            child: TwoSwitch(
              first: _getSavedButton(true),
              second: _getSavedButton(false),
              isFirst: _current.isSaved,
              onTap: () {
                onCategorySaved(_current);
              },
            ),
          ),
        )
      ],
    );
  }
}

Widget _getSavedButton(bool isSaved) {
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
  CategoryConfig({this.showTranslate = false});
}

class CategoryModel extends Model {
  CategoryConfig config = new CategoryConfig();

  bool get isShowTranslate => config.showTranslate;

  void onChangeTranslate() {
    config.showTranslate = !config.showTranslate;
    notifyListeners();
  }
}
