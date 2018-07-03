import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/widgets/page_categories.dart';
import 'package:scoped_model/scoped_model.dart';

class WordsCard extends StatelessWidget {
  final List<Word> words;

  WordsCard({Key key, @required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CategoryModel>(
        builder: (context, _, model) => Column(
              children: words
                  .map((word) => new AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: _full(word, context),
                        secondChild: _light(word, context),
                        crossFadeState: model.isShowTranslate
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ))
                  .toList(),
            ));
  }

  Widget _full(Word word, BuildContext context) {
    var theme = Theme.of(context);

    var eng = Text(
      word.eng,
      softWrap: true,
      style: theme.textTheme.title,
    );

    var rus = Text(
      word.rus,
      softWrap: true,
      style: theme.textTheme.subhead,
    );

    var expanded = Container(
        child: new Text(
      word.transcr,
      style: theme.textTheme.subhead,
      softWrap: true,
    ));

    return Container(
      margin: EdgeInsets.only(
          top: word.isBase ? Style.itemPadding : Style.smallPadding,
          left: Style.smallPadding,
          right: Style.smallPadding),
      padding: const EdgeInsets.only(right: Style.itemPadding),
      decoration: BoxDecoration(
        color: Style.darkBG,
        borderRadius: BorderRadius.circular(Style.itemPadding),
      ),
      child: ExpansionTile(
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.0,
                  color: word.isBase ? theme.accentColor : theme.primaryColor),
              shape: BoxShape.circle,
              color: theme.canvasColor),
          width: Style.bigItemPadding,
          height: Style.bigItemPadding,
        ),
        trailing: SizedBox(),
        initiallyExpanded: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            eng,
            rus,
          ],
        ),
        children: <Widget>[
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: Style.smallPadding),
                  child: expanded,
                ),
              ]),
        ],
      ),
    );
  }

  Widget _light(Word word, BuildContext context) {
    var theme = Theme.of(context);

    var eng = Text(
      word.eng.toUpperCase(),
      style: theme.textTheme.headline
          .copyWith(color: word.isBase ? theme.accentColor : Style.grey),
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
          Expanded(child: eng),
        ],
      ),
    );
  }
}
