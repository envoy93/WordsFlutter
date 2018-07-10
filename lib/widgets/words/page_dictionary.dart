import 'package:flutter/material.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/words/list_words.dart';

class DictionaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DictionaryPageState();
  }
}

class DictionaryPageState extends TopCategoriesPageState<DictionaryPage> {
  @override
  Widget list(Category topCategory) {
    return WordsList(key: Key("pd-wl${topCategory.id}"), category: topCategory);
  }
}
