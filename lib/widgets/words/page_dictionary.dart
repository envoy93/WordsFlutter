import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/menu.dart';
import 'package:hello_world/widgets/utils/backdrop.dart';
import 'package:hello_world/widgets/words/list_words.dart';

class DictionaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DictionaryPageState();
  }
}

class DictionaryPageState extends BackDropWidgetState<DictionaryPage> {
  AnimationController controller;

  @protected
  Widget get title => Text(W.words);

  @protected
  Widget get backpanel => Menu(MenuItem.Words, (item) {
        if (item == MenuItem.Words) controller.fling(velocity: 1.0);
      });

  @protected
  Widget get body => Dictionary();
}

class Dictionary extends StatefulWidget {
  Dictionary({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DictionaryState();
  }
}

class DictionaryState extends TopCategoriesState<Dictionary> {
  @override
  Widget list(Category topCategory) {
    return WordsList(key: Key("pd-wl${topCategory.id}"), category: topCategory);
  }
}
