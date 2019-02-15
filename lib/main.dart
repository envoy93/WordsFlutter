import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hello_world/providers/db/db.dart';
import 'package:hello_world/providers/preferences_provider.dart';
import 'package:hello_world/providers/words_provider.dart';
import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/page_splash.dart';
import 'package:hello_world/widgets/words/page_dictionary.dart';
import 'package:hello_world/widgets/categories/page_categories.dart';
import 'package:hello_world/providers/blocs/app_bloc.dart';
import 'package:fluro/fluro.dart';

void main() async {
  final DatabaseConnection database = DatabaseClient();

  runApp(
    Providers(
      CachedCategoriesProvider(CategoriesProvider(database)),
      CachedWordsProvider(WordsProvider(database)),
      PreferencesProvider(await SharedPreferences.getInstance()),
      child: new MyApp(database),
      //child: MaterialApp(home: Scaffold(body: Test())),
    ),
  );
}

class MyApp extends StatelessWidget {
  final DatabaseConnection _conn;

  MyApp(this._conn);

  @override
  Widget build(BuildContext context) {
    var base = Theme.of(context);

    var router = new Router();

    router.define(
      AppRoute.CATEGORIES,
      handler: Handler(
        handlerFunc: (_, Map<String, dynamic> params) => TopCategoriesPage(
            initialData: int.parse(params[RouteParam.TOP_CATEGORY][0])),
      ),
    );

    router.define(
      AppRoute.WORDS,
      handler: Handler(
        handlerFunc: (_, Map<String, dynamic> params) => DictionaryPage(
            initialData: int.parse(params[RouteParam.TOP_CATEGORY][0])),
      ),
    );

    router.define(
      AppRoute.CATEGORY,
      handler: Handler(
        handlerFunc: (_, Map<String, dynamic> params) => CategoriesPage(
            categoryId: int.parse(params[RouteParam.CATEGORY][0]),
            subCategoryId: int.parse(params[RouteParam.SUB_CATEGORY][0])),
      ),
    );

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        accentColor: Style.offBG, //Colors.orangeAccent[400],
        primaryColor: Colors.white, //Color(0xff1e1e28),
        brightness: Brightness.light,

        canvasColor: Style.lightGrey, //Color(0xff2e2f41),
        backgroundColor: Style.lightGrey, //Color(0xff2e2f41),
        scaffoldBackgroundColor: Style.lightGrey, //Color(0xff2e2f41),
        bottomAppBarColor: Color(0xff1e1e28),

        dividerColor: Colors.transparent, //Color(0xff2e2f41),
        buttonColor: Color(0xff1e1e28),
        cardColor: Style.darkBG,
        iconTheme: base.primaryIconTheme.copyWith(color: Style.offBG),

        textSelectionColor: Colors.redAccent[300],
        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
      ),
      home: SplashScreenPage(_conn),
      onGenerateRoute: router.generator,
    );
  }

  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline: base.headline.copyWith(fontWeight: FontWeight.w500),
          title: base.title.copyWith(
            color: Colors.black,
            fontSize: 16.0,
          ),
          subhead: base.subhead.copyWith(
            color: Style.grey,
            fontSize: 14.0,
          ),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            color: Style.grey,
            fontSize: 13.0,
          ),
        )
        .apply(
            //fontFamily: 'Rubik',
            //displayColor: Colors.black,
            //bodyColor: Colors.black
            );
  }
}

class Style {
  static const Color darkBG = Color(0xff23232b);
  static const Color grey = Color(0xff444444);
  static const Color lightGrey = Color(0xffeaedf2);

  static const Color onBG = Color(0xffe5e6ed); //Color(0xff23232b);
  static const Color offBG = Color(0xffff1844);
}



class W {
  static const String savedCategory = 'Выучено';
  static const String unsavedCategory = 'Не выучено';

  static const String savedWord = 'Выучено';
  static const String unsavedWord = 'Не выучено';

  static const String error = 'Произошла непредвиденная ошибка';
  static const String reload = 'Обновить';

  static const String words = 'Слова';

  static const String categories = 'Категории';

  static const String title = "Словаблабла";
}

class WE {
  static const String savedCategory = 'Действие не удалось';
  static const String savedWord = 'Действие не удалось';
}

class AppRoute {
  static const String _CATEGORIES = "categories";
  static const String _WORDS = "words";
  static const String _CATEGORY = "category";

  static const String CATEGORIES = "$_CATEGORIES/:${RouteParam.TOP_CATEGORY}";
  static const String WORDS = "$_WORDS/:${RouteParam.TOP_CATEGORY}";
  static const String CATEGORY =
      "$_CATEGORY/:${RouteParam.CATEGORY}/:${RouteParam.SUB_CATEGORY}";

  static String categories({int topCategory: -1}) =>
      "$_CATEGORIES/$topCategory";
  static String words({int topCategory: -1}) => "$_WORDS/$topCategory";
  static String category({@required int category, int subCategory: -1}) =>
      "$_CATEGORY/$category/$subCategory";
}

class RouteParam {
  static const TOP_CATEGORY = "topCategory";

  static const CATEGORY = "category";
  static const SUB_CATEGORY = "subCategory";
}

void message(String text, BuildContext context,
    {Color color: Style.lightGrey}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: Theme.of(context).textTheme.title,
    ),
    backgroundColor: color,
  ));
}
