import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/page_categories.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/switch.dart';
import 'package:hello_world/widgets/words/page_word.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return await Providers.of(context).words.forCategory(widget.category.id);
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
      builder: (context, List<Word> data) => Column(
            children: data
                .map((word) => WordWidget(
                      word: word,
                    ))
                .toList(),
          ),
    );
  }
}

class WordWidget extends StatefulWidget {
  final Word word;
  WordWidget({Key key, @required this.word}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WordWidgetState(word);
  }
}

class WordWidgetState extends ActiveState<WordWidget> {
  Word _word;
  WordWidgetState(this._word);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
        builder: (context, _, model) => new AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: _full(_word),
              secondChild: _light(_word),
              crossFadeState: (model == null ? true : model.isShowTranslate)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ));
  }

  Widget _full(Word word) {
    var theme = Theme.of(context);

    var eng = Text(
      word.eng,
      softWrap: true,
      style: theme.textTheme.title
          .copyWith(color: word.isSaved ? Colors.white : Style.offBG),
    );

    var rus = Text(
      word.rus,
      softWrap: true,
      style: theme.textTheme.subhead.copyWith(color: Style.grey),
    );

    return Container(
      margin: EdgeInsets.only(
          top: word.isBase ? Style.itemPadding : Style.smallPadding,
          left: Style.smallPadding,
          right: Style.smallPadding),
      decoration: BoxDecoration(
        color: Style.darkBG,
        borderRadius: BorderRadius.circular(Style.itemPadding),
      ),
      child: ListTile(
        isThreeLine: false,
        onTap: () {
          _onWordClick(word);
        },
        leading: word.isBase
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: theme.accentColor),
                    shape: BoxShape.circle,
                    color: theme.canvasColor),
                width: Style.bigItemPadding,
                height: Style.bigItemPadding,
              )
            : SizedBox(),
        title: eng,
        subtitle: rus,
      ),
    );
  }

  Widget _light(Word word) {
    var theme = Theme.of(context);

    var eng = Text(
      word.eng.toUpperCase(),
      style: theme.textTheme.headline.copyWith(
          color: !word.isSaved
              ? Style.offBG
              : word.isBase ? theme.accentColor : Style.grey),
      textAlign: TextAlign.center,
      overflow: TextOverflow.fade,
      softWrap: true,
    );

    return Padding(
      padding: EdgeInsets.only(
          left: Style.itemPadding,
          right: Style.itemPadding,
          top: (word.isBase ? Style.itemPadding : Style.smallPadding)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: eng,
            onTap: () {
              _onWordClick(word);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onWordSaved(Word word, BuildContext context) async {
    final provider = Providers.of(context).words;
    await new Future.delayed(new Duration(seconds: 1));
    if (!await provider.changeSave(word)) {
      // error
      return false;
    } else if (isActive) {
      setState(() {});
    }
    return true;
  }

  void _onWordClick(Word word) {
    var theme = Theme.of(context);
    final button = Theme(
      data: theme.copyWith(buttonColor: Style.offBG),
      child: TwoSwitch(
        onError: WE.savedWord,
        isFirst: _word.isSaved,
        first: _savedButton(true),
        second: _savedButton(false),
        onTap: (context) async {
          return _onWordSaved(word, context);
        },
      ),
    );
    showModalBottomSheet(
      context: context,
      builder: (context) => WordPage(
            button: button,
            word: word,
          ),
    );
  }

  Widget _savedButton(bool isSaved) {
    return Row(
      children: <Widget>[
        Icon(isSaved ? Icons.star : Icons.star_border),
        SizedBox(width: Style.smallPadding),
        Text((isSaved ? W.savedWord : W.unsavedWord).toUpperCase())
      ],
    );
  }
}
