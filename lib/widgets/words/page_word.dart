import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';

class WordPage extends StatefulWidget {
  final Word word;
  final Widget button;

  WordPage({Key key, @required this.word, this.button}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WordPageState(word, button);
  }
}

class _WordPageState extends State<WordPage> {
  Word _word;
  Widget _button;

  _WordPageState(this._word, this._button);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final subtitle = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Style.itemPadding),
        color: Style.onBG,
      ),
      padding: EdgeInsets.all(Style.itemPadding),
      child: Text(
        _word.rus,
        textAlign: TextAlign.center,
        style: theme.textTheme.title,
      ),
    );

    final title = Container(
      padding: const EdgeInsets.all(Style.itemPadding),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [const Color(0xFF6532ce), const Color(0xFF6964f0)],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              _word.eng,
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.display1.copyWith(color: theme.primaryColor),
            ),
            SizedBox(
              height: Style.bigItemPadding,
            ),
            subtitle
          ],
        ),
      ),
    );

    final info = Padding(
      padding: const EdgeInsets.all(Style.itemPadding),
      child: Column(
        children: <Widget>[
          Text(
            _word.transcr,
            style: theme.textTheme.subhead.copyWith(color: Style.grey),
            textAlign: TextAlign.center,
          ),
          Text(
            _word.example,
            style: theme.textTheme.subhead.copyWith(color: Style.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final size = MediaQuery.of(context).size;
    final direction = ((size.width < size.height) || (_button == null))
        ? Axis.vertical
        : Axis.horizontal;

    return Container(
      color: theme.primaryColor,
      child: Scrollbar(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            title,
            Flex(
              direction: direction,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                info,
                _button == null
                    ? SizedBox()
                    : FittedBox(
                        fit: BoxFit.cover,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Style.itemPadding),
                          child: _button,
                        ),
                      )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
