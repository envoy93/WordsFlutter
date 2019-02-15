import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/providers/blocs/category_bloc.dart';
import 'package:hello_world/widgets/utils/switch.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/categories/word.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard(this.category, {Key key}) : super(key: key);

  @override
  _CategoryCardState createState() {
    return _CategoryCardState();
  }
}

class _CategoryCardState extends State<CategoryCard>
    implements AutomaticKeepAliveClientMixin<CategoryCard> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      children: [
        _header,
        _words(widget.category.id),
        _footer,
      ],
      padding: const EdgeInsets.only(bottom: AppDimensions.bigItemPadding),
    );
  }

  Widget _words(int categoryId) {
    var bloc = CategoryBlocProvider.of(context);
    bloc.fetchWords(widget.category.id);
    return StreamBuilder<Map<int, Future<List<Word>>>>(
      stream: bloc.words,
      builder: (context, snapshot) {
        if (!snapshot.hasData || (snapshot.data[widget.category.id] == null)) {
          return LoadingWidget(color: Colors.black);
        }

        var words = snapshot.data[widget.category.id];
        return FutureBuilder<List<Word>>(
          future: words,
          builder: (context, data) => (data.data == null)
              ? LoadingWidget(color: Colors.black)
              : Column(
                  children: data.data
                      .map((word) => WordWidget(
                            word: word,
                          ))
                      .toList(),
                ),
        );
      },
    );
  }

  Widget get _header {
    var theme = Theme.of(context);
    return ListTile(
      dense: true,
      title: Text(
        (widget.category.title + ',').toUpperCase(),
        style: theme.textTheme.headline,
      ),
      subtitle: Text(
        (widget.category.isSaved ? W.savedCategory : W.unsavedCategory)
            .toUpperCase(),
        style: theme.textTheme.title.copyWith(color: Color(0xff888888)),
      ),
    );
  }

  Widget get _footer {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.bigItemPadding),
          child: Column(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(buttonColor: Style.offBG),
                child: CallbackSwitch(
                  initialData: widget.category.isSaved,
                  first: PassiveButton(
                      hasIcon: true,
                      text: W.savedCategory.toUpperCase(),
                      textColor: Colors.black),
                  second: ActiveButton(
                    hasIcon: true,
                    text: W.unsavedCategory.toUpperCase(),
                    textColor: Colors.white,
                  ),
                  onSwitch: (context) async {
                    await Providers.of(context)
                        .categories
                        .changeSave(widget.category);
                    setState(() {});
                    return widget.category.isSaved;
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void updateKeepAlive() {
    //TODO wtf???
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
