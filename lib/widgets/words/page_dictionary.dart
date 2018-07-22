import 'package:flutter/material.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/drawer.dart';
import 'package:hello_world/widgets/words/list_words.dart';

class DictionaryPage extends StatefulWidget {
  DictionaryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DictionaryPageState();
  }
}

class DictionaryPageState extends TopCategoriesPageState<DictionaryPage> {
  @override
  DrawerItem item = DrawerItem.Words;

  @override
  Widget list(Category topCategory) {
    return WordsList(key: Key("pd-wl${topCategory.id}"), category: topCategory);
  }
}
