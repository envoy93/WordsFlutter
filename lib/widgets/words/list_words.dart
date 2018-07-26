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
      list.addAll(words.where((w) => !w.isSaved)); //TODO use special db request
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
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) => Dismissible(
                      direction: DismissDirection.horizontal,
                      child: _word(data[index]),
                      background: Container(color: Style.offBG),
                      key: Key("pd-wl-w${data[index].id}"),
                      onDismissed: (direction) {
                        var w = data[index];
                        data.removeAt(index);
                        Providers.of(context).words.changeSave(w);
                      },
                    ),
              ),
            ));
  }

  Widget _circle() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: Theme.of(context).accentColor),
          shape: BoxShape.circle,
          color: Colors.transparent),
      width: Style.itemPadding,
      height: Style.itemPadding,
    );
  }

  Widget _word(Word word) {
    final theme = Theme.of(context);

    var eng = Text(
      word.eng,
      softWrap: true,
      style: theme.textTheme.title.copyWith(
          fontWeight: word.isBase ? FontWeight.w900 : FontWeight.w400),
    );
    var rus = Text(
      word.rus,
      softWrap: true,
      style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.w300),
    );

    return Container(
      child: ListTile(
        leading: _circle(),
        isThreeLine: false,
        title: eng,
        subtitle: rus,
        dense: true,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => WordPage(
                  word: word,
                ),
          );
        },
      ),
    );
  }
}
