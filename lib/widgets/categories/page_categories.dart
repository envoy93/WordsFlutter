import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/dimensions.dart';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/category.dart';
import 'package:hello_world/providers/blocs/category_bloc.dart';
import 'package:hello_world/providers/blocs/app_bloc.dart';
import 'package:hello_world/widgets/utils/fullscreen.dart';

class CategoriesPage extends StatefulWidget {
  final int subCategoryId;
  final int categoryId;

  CategoriesPage({
    Key key,
    @required this.categoryId,
    @required this.subCategoryId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPageState();
  }
}

class _CategoriesPageState extends State<CategoriesPage> {
  ScrollController _scrollController;
  PageController _pageController;
  CategoryBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = new CategoryBloc(
      wordsProvider: Providers.of(context).words,
      categoriesProvider: Providers.of(context).categories,
    );
    _bloc.fetchCategories(widget.categoryId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _scrollController?.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CategoryBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Style.lightGrey,
        appBar: AppBar(
          backgroundColor: Style.lightGrey,
          elevation: 0.0,
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: StreamBuilder(
            initialData: null,
            stream: _bloc.categories,
            builder: (context, AsyncSnapshot<List<Category>> categories) {
              if (!categories.hasData) {
                return loading;
              }

              if (_pageController == null) {
                var index = categories.data
                    .indexWhere((c) => c.id == widget.subCategoryId);
                _pageController =
                    PageController(initialPage: index, keepPage: true);
              }
              return body(categories.data);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: button,
      ),
    );
  }

  /*final indicator = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Style.itemPadding, vertical: Style.smallPadding),
        child: RectangleIndicator(
          pageController,
          widget.categories.length,
          Style.itemPadding / 2,
          Color(0xffcccccc),
          Style.grey,
          initialPage: _current,
        ),
      ),
    );*/

  Widget get button {
    final settings = AppBlocProvider.of(context);
    return StreamBuilder(
      stream: settings.fullWordView,
      builder: (_, f) {
        if (!f.hasData) return CircularProgressIndicator();
        return FloatingActionButton(
          mini: true,
          child: Icon(f.data ? Icons.short_text : Icons.subject),
          isExtended: false,
          shape: const CircleBorder(),
          onPressed: () {
            settings.updateFullWordView(!f.data);
          },
        );
      },
    );
  }

  Widget get loading => LoadingWidget(
        color: Colors.black,
      );

  Widget body(List<Category> categories) => Stack(
        children: <Widget>[
          //indicator,
          Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.bigItemPadding),
            child: PageView.builder(
              onPageChanged: (i) {
                //_current = i;
              },
              controller: _pageController,
              itemCount: categories.length,
              itemBuilder: (context, index) => CategoryCard(
                    // TODO show page index
                    categories[index],
                    key: Key("pc-c${categories[index]}"),
                  ),
            ),
          ),
        ],
      );
}
