import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';
import 'package:hello_world/widgets/categories/page_top_categories.dart';
import 'package:hello_world/widgets/words/page_dictionary.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationWidgetState();
  }
}

class NavigationWidgetState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(

            child: SizedBox(),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(W.words, style: theme.textTheme.title),
            onTap: () {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) {
                return DictionaryPage();
              }));
            },
          ),
          ListTile(
            title: Text(W.categories,style: theme.textTheme.title),
            onTap: () {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) {
                return TopCategoriesPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
