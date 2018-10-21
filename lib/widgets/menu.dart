import 'package:flutter/material.dart';
import 'package:hello_world/main.dart';

enum MenuItem { Words, Categories }
typedef void MenuOnTap(MenuItem item);

class Menu extends StatelessWidget {
  final MenuItem current;
  final MenuOnTap onTap;

  Menu(this.current, this.onTap, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(Style.bigItemPadding),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _item(
                W.categories.toUpperCase(),
                MenuItem.Categories,
                context,
                onTap: onTap,
              ),
              _item(
                W.words.toUpperCase(),
                MenuItem.Words,
                context,
                onTap: onTap,
              )
            ],
          ),
        );
  }

  Widget _item(String text, MenuItem type, BuildContext context,
      {MenuOnTap onTap}) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(Style.itemPadding),
        child: Text(text,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline
                .copyWith(color: current == type ? Style.offBG : Colors.black)),
      ),
      onTap: current != type
          ? () {
              if (onTap != null) onTap(type);
              Navigator.pushReplacementNamed(context, "/$type");
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text("/$type")));
            }
          : () {
              if (onTap != null) onTap(type);
            },
    );
  }
}
