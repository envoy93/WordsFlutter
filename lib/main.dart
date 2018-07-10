import 'package:flutter/material.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/providers/widget.dart';
import 'package:hello_world/widgets/page_splash.dart';

void main() => runApp(
      Providers(
        dbClient: DatabaseClient(),
        child: new MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var base = Theme.of(context);

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        accentColor: Colors.orangeAccent[400],
        primaryColor: Color(0xff1e1e28),
        brightness: Brightness.dark,
        dividerColor: Color(0xff2e2f41),
        canvasColor: Color(0xff2e2f41),
        textSelectionColor: Colors.orangeAccent[400],
        backgroundColor: Color(0xff2e2f41),
        scaffoldBackgroundColor: Color(0xff2e2f41),
        buttonColor: Color(0xff1e1e28),
        cardColor: Style.darkBG,
        bottomAppBarColor: Color(0xff1e1e28),
        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
        iconTheme: base.primaryIconTheme.copyWith(
          color: Colors.orangeAccent[400],
        ),
      ),
      home: SplashScreenPage(),
      routes: <String, WidgetBuilder>{},
    );
  }

  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline: base.headline.copyWith(fontWeight: FontWeight.w500),
          title: base.title.copyWith(fontSize: 18.0),
          subhead: base.subhead.copyWith(color: Colors.grey, fontSize: 16.0),
          caption: base.caption.copyWith(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 14.0),
        )
        .apply(
          //fontFamily: 'Rubik',
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }
}

class Style {
  static const double smallPadding = 3.0;
  static const double itemPadding = 10.0;
  static const double bigItemPadding = 20.0;

  static const Color darkBG = Color(0xff23232b);
  static const Color grey = Color(0xffcccccc);

  static const Color onBG = Color(0xff23232b);
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

  static String words = 'Слова';

  static String categories = 'Категории';
}

class WE {
  static const String savedCategory = 'Действие не удалось';
  static const String savedWord = 'Действие не удалось';
}

void message(String text, BuildContext context, {Color color = Style.onBG}) {
  Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: color,
      ));
}
