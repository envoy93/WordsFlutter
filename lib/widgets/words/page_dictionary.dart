import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/words/list_words.dart';

class DictionaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DictionaryPageState();
  }
}

class DictionaryPageState extends TopCategoriesPageState<DictionaryPage> {
  @override
  Widget content(List<Category> data, int init) {
    return Dictionary(data, init);
  }
}

class Dictionary extends TopCategories {
  Dictionary(List<Category> topCategories, int init)
      : super(topCategories, init);

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
    return WordsList(key: Key("pd-wl${topCategory.id}"), category: topCategory);
  }
}
