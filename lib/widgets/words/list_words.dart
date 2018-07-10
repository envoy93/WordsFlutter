import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/words/page_word.dart';

class WordsList extends StatefulWidget {
  final Category category;

  WordsList({Key key, @required this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WordsListState();
  }
}

class WordsListState extends State<WordsList> {
  Future<List<Word>> _state;

  Future<List<Word>> onLoad() async {
    await new Future.delayed(new Duration(seconds: 1));
    final List<Word> list = List();
    final top2 = await Providers
        .of(context)
        .categories
        .forParentRecursive(widget.category.id);
    final top3 = top2.expand((c) => c.childs).toList();
    for (var c in top3) {
      final words = await Providers.of(context).words.forCategory(c.id);
      list.addAll(words.where((w)=> !w.isSaved)); //TODO use special db request
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFutureBuilder<List<Word>>(
        onReload: () {
          setState(() {
            _state = null;
          });
        },
        future: _state ?? (_state = onLoad()),
        builder: (_, List<Word> data) => Scrollbar(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Dismissible(
                      child: _word(data[index]),
                      background: Container(color: Style.offBG),
                      key: Key("pd-wl-w${data[index].id}"),
                      onDismissed: (direction) {
                        Providers.of(context).words.changeSave(data[index]);
                        data.removeAt(index);
                      },
                    ),
              ),
            ));
  }

  Widget _word(Word word) {
    return ListTile(
      isThreeLine: false,
      title: Text(word.eng),
      subtitle: Text(word.rus),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => WordPage(
                word: word,
              ),
        );
      },
    );
  }
}
