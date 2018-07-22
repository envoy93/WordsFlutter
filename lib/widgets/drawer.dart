import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';

enum DrawerItem { Words, Categories }

class NavigationDrawer extends StatelessWidget {
  final DrawerItem current;

  NavigationDrawer(this.current, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Style.offBG,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(W.title),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            _item(W.categories.toUpperCase(), DrawerItem.Categories, context),
            _item(W.words.toUpperCase(), DrawerItem.Words, context)
          ],
        ),
      ),
    );
  }

  Widget _item(String text, DrawerItem type, BuildContext context,
      {GestureTapCallback onTap}) {
    return ListTile(
      dense: true,
      enabled: true,
      title: Text(text, style: Theme.of(context).textTheme.headline.copyWith(color:current == type? Style.offBG: Colors.black)),
      onTap: () {
        if (current != type) {
          if (onTap != null) onTap();
          Navigator.pushReplacementNamed(context, "/$type");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("/$type")));
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
