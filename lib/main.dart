import 'package:flutter/material.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/drawer.dart';
import 'package:hello_world/widgets/page_splash.dart';
import 'package:hello_world/widgets/words/page_dictionary.dart';

void main() => runApp(
      Providers(
        dbClient: DatabaseClient(),
        child: new MyApp(),
        //child: MaterialApp(home: Scaffold(body: Test())),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var base = Theme.of(context);

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        accentColor: Style.offBG,//Colors.orangeAccent[400],
        primaryColor: Colors.white, //Color(0xff1e1e28),
        brightness: Brightness.light,
        dividerColor: Colors.transparent, //Color(0xff2e2f41),
        canvasColor: Style.lightGrey, //Color(0xff2e2f41),
        textSelectionColor: Colors.redAccent[300],
        backgroundColor: Style.lightGrey, //Color(0xff2e2f41),
        scaffoldBackgroundColor: Style.lightGrey, //Color(0xff2e2f41),
        buttonColor: Color(0xff1e1e28),
        cardColor: Style.darkBG,
        bottomAppBarColor: Color(0xff1e1e28),
        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
        iconTheme: base.primaryIconTheme.copyWith(
          color: Style.offBG,
        ),
      ),
      home: SplashScreenPage(),
      routes: <String, WidgetBuilder>{
        '/${DrawerItem.Categories}': (BuildContext context) =>
            TopCategoriesPage(),
        '/${DrawerItem.Words}': (BuildContext context) => DictionaryPage()
      },
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
  static const double smallPadding = 3.0;
  static const double itemPadding = 10.0;
  static const double bigItemPadding = 20.0;

  static const Color darkBG = Color(0xff23232b);
  static const Color grey = Color(0xff444444);
  static const Color lightGrey = Color(0xffeaedf2);

  static const Color onBG = Color(0xffe5e6ed); //Color(0xff23232b);
  static const Color offBG = Color(0xffff1844);

  static var shape = BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(Style.itemPadding));
  static const padding = const EdgeInsets.all(Style.itemPadding);
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

void message(String text, BuildContext context, {Color color: Style.lightGrey}) {
  Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text, style: Theme.of(context).textTheme.title,),
        backgroundColor: color,
      ));
}
