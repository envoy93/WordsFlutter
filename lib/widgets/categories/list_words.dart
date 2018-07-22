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
      style: theme.textTheme.title.copyWith(
          fontWeight: word.isBase ? FontWeight.w900 : FontWeight.w400),
    );
    var rus = Text(
      word.rus,
      softWrap: true,
      style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.w300),
    );

    return ListTile(
      isThreeLine: false,
      onTap: () {
        _onWordClick(word);
      },
      leading: !word.isSaved ? _circle() : SizedBox(),
      title: eng,
      subtitle: rus,
      dense: true,
    );
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

  Widget _light(Word word) {
    var theme = Theme.of(context);

    var eng = Text(
      word.eng.toUpperCase(),
      style: theme.textTheme.headline.copyWith(
          color: Style.grey,
          fontWeight: word.isBase ? FontWeight.w900 : FontWeight.w400),
      textAlign: TextAlign.center,
      overflow: TextOverflow.fade,
      softWrap: true,
    );

    return InkWell(
      onTap: () {
        _onWordClick(word);
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: Style.itemPadding,
            right: Style.itemPadding,
            top: (word.isBase ? Style.bigItemPadding : Style.smallPadding)),
        child: Row(
          children: <Widget>[
            word.isSaved
                ? SizedBox(
                    width: Style.itemPadding,
                  )
                : _circle(),
            Expanded(child: eng),
          ],
        ),
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
    final theme = Theme.of(context).textTheme;
    final color = isSaved ? Colors.black : Colors.white;

    return Row(
      children: <Widget>[
        Icon(isSaved ? Icons.star : Icons.star_border, color: color),
        SizedBox(width: Style.smallPadding),
        Text((isSaved ? W.savedWord : W.unsavedWord).toUpperCase(),
            style: theme.title.copyWith(color: color))
      ],
    );
  }
}
