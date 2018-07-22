import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/list_words.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';
import 'package:hello_world/widgets/utils/switch.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard(this.category, {Key key}) : super(key: key);

  @override
  _CategoryCardState createState() {
    return _CategoryCardState(
      category,
    );
  }
}

class _CategoryCardState extends ActiveState<CategoryCard>
    with AutomaticKeepAliveClientMixin<CategoryCard> {
  Category _category;
  final ScrollController controller = ScrollController();

  _CategoryCardState(this._category);

  Future<bool> _onCategorySaved(Category data, BuildContext context) async {
    final provider = Providers.of(context).categories;
    await new Future.delayed(new Duration(seconds: 1));
    if (!await provider.changeSave(data)) {
      // error
      return false;
    } else if (isActive) {
      setState(() {});
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      children: [
        _header(_category),
        WordsList(key: Key("cc-wcl${_category.id}"), category: _category),
        _footer(_category),
      ],
      padding: const EdgeInsets.only(bottom: Style.bigItemPadding),
    );
  }

  Widget _header(Category data) {
    var theme = Theme.of(context);
    return ListTile(
      dense: true,
      title: Text(
        (data.title + ',').toUpperCase(),
        style: theme.textTheme.headline,
      ),
      subtitle: Text(
        (data.isSaved ? W.savedCategory : W.unsavedCategory).toUpperCase(),
        style: theme.textTheme.title.copyWith(color: Color(0xff888888)),
      ),
    );
  }

  Widget _footer(Category data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: Style.bigItemPadding),
          child: Column(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(buttonColor: Style.offBG),
                child: TwoSwitch(
                  first: _savedButton(true),
                  second: _savedButton(false),
                  onError: WE.savedCategory,
                  isFirst: data.isSaved,
                  onTap: (context) async {
                    return _onCategorySaved(data, context);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _savedButton(bool isSaved) {
    final theme = Theme.of(context).textTheme;
    final color = isSaved ? Colors.black : Colors.white;
    return Row(
      children: <Widget>[
        Icon(isSaved ? Icons.star : Icons.star_border, color: color,),
        SizedBox(width: Style.smallPadding),
        Text(
          (isSaved ? W.savedCategory : W.unsavedCategory).toUpperCase(),
          style: theme.title
              .copyWith(color: color),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
