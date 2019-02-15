import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/words/list_words.dart';

class DictionaryPage extends StatefulWidget {
  final int initialData;

  DictionaryPage({this.initialData: -1, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DictionaryPageState(initialData);
  }
}

class DictionaryPageState extends TopCategoriesPageState<DictionaryPage> {
  DictionaryPageState(initialData) : super(initialData);

  @override
  Widget content(List<Category> data) {
    return Dictionary(data);
  }
}

class Dictionary extends TopCategories {
  Dictionary(List<Category> topCategories)
      : super(topCategories: topCategories);

  @override
  State<StatefulWidget> createState() {
    return DictionaryState();
  }
}

class DictionaryState extends TopCategoriesState {
  AnimationController controller;

  @protected
  Widget get title => Text(W.words);

  @protected
  Widget get backpanel => Menu(MenuItem.Words, (item) {
        if (item == MenuItem.Words) controller.fling(velocity: 1.0);
      });

  @override
  Widget list(Category topCategory) {
    //return WordsList(key: Key("pd-wl${topCategory.id}"), category: topCategory);
    return Text("words for ${topCategory.title}"); //TODO words list
  }
}
