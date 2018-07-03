import 'package:flutter/material.dart';
import 'package:hello_world/providers/db.dart';
import 'package:hello_world/widgets/page_splash.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static final DatabaseClient databaseClient = new DatabaseClient();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var base = Theme.of(context);

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.dark,
        dividerColor: Color(0xff2e2f41),
        buttonColor: Color(0xff1e1e28),
        cardColor: Style.darkBG,//Color(0xff1e1e28), //TODO
        //backgroundColor: Colors.red,
        canvasColor: Color(0xff2e2f41), //Color(0xff1e1e28),
        accentColor: Colors.orangeAccent[400],
        primaryColor: Color(0xff1e1e28),
        scaffoldBackgroundColor: Color(0xff2e2f41),
        textSelectionColor: Colors.orangeAccent[400],
        bottomAppBarColor: Color(0xff1e1e28),
        //primarySwatch: Colors.blue,

        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
        iconTheme: base.primaryIconTheme.copyWith(
          color: Colors.orangeAccent[400],
        ),
      ),

      home: SplashScreenPage(),
      routes: <String, WidgetBuilder>{
        //"/hui" : (BuildContext context)=> new Text("test"),
      }, //SplashScreenPage()
      /*new Scaffold(
          appBar: new AppBar(title: new Text("category")),
          body: new CategoriesWidget(current: 1, categories: categories1()),
        ),*/
    );
  }

  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline: base.headline.copyWith(
            fontWeight: FontWeight.w500,
          ),
          title: base.title.copyWith(
            fontSize: 18.0,
          ),
          subhead: base.subhead.copyWith(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 14.0,
          ),
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
}

class W {
  static const String savedCategory = "Выучено";
  static const String unsavedCategory = "Не выучено";

  static const String error = "Произошла непредвиденная ошибка";
}
