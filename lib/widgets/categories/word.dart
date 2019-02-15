import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/switch.dart';
import 'package:hello_world/widgets/words/page_word.dart';
import 'package:hello_world/providers/blocs/app_bloc.dart';

class WordWidget extends StatefulWidget {
  final Word word;
  WordWidget({Key key, @required this.word}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WordWidgetState();
  }
}

class WordWidgetState extends State<WordWidget> {
  WordWidgetState();

  @override
  Widget build(BuildContext context) {
    var bloc = AppBlocProvider.of(context);
    var theme = Theme.of(context);

    return StreamBuilder<bool>(
      stream: bloc.fullWordView,
      builder: (context, snapshot) {
        return ReloadWidget<bool>(
          snapshot: snapshot,
          onError: (error) => _word(true),
          onLoading: LoadingWidget(color: theme.textTheme.headline.color),
          onData: (data) => _word(data),
        );
      },
    );
  }

  Widget _word(bool isFull) => AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: _full(widget.word),
        secondChild: _light(widget.word),
        crossFadeState:
            (isFull) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      );

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
      width: AppDimensions.itemPadding,
      height: AppDimensions.itemPadding,
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
            left: AppDimensions.itemPadding,
            right: AppDimensions.itemPadding,
            top: (word.isBase ? AppDimensions.bigItemPadding : AppDimensions.smallPadding)),
        child: Row(
          children: <Widget>[
            word.isSaved
                ? SizedBox(
                    width: AppDimensions.itemPadding,
                  )
                : _circle(),
            Expanded(child: eng),
          ],
        ),
      ),
    );
  }

  void _onWordClick(Word word) {
    var theme = Theme.of(context);
    final button = Theme(
      data: theme.copyWith(buttonColor: Style.offBG),
      child: CallbackSwitch(
        first: PassiveButton(
          text: W.savedWord,
          textColor: Colors.black,
          hasIcon: Icons.star,
        ),//_savedButton(true),
        second: ActiveButton(
          text: W.unsavedCategory,
          textColor: Colors.white,
          hasIcon: true,
        ),
        initialData: word.isSaved,
        onSwitch: (context) async {
          await Providers.of(context).words.changeSave(word);
          setState(() {});
          return word.isSaved;
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

}
