import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesProvider {
  final DatabaseClient client;
  final String table = "categories";
  final Map<int, List<Category>> cacheByParent = new Map();
  final Map<int, List<Category>> cacheByLevel = new Map();

  CategoriesProvider(this.client);

  Future<Category> forId(int id) async {
    await client.open();
    List<Map> results = await client.db.query(table,
        columns: Category.columns, where: "id = ?", whereArgs: [id]);
    var res = Category.fromMap(results[0]);
    await client.close();
    return res;
  }

  Future<List<Category>> _forParent(int id) async {
    if (!cacheByParent.containsKey(id)) {
      await client.open();
      List<Map> results = await client.db.query(table,
          columns: Category.columns,
          where: "parent_id = ?",
          orderBy: "position",
          whereArgs: [id]);
      await client.close();
      cacheByParent[id] = results.map<Category>(Category.fromMap).toList();
    }
    return cacheByParent[id];
  }

  Future<List<Category>> forLevel(int lvl) async {
    if (!cacheByLevel.containsKey(lvl)) {
      await client.open();
      List<Map> results = await client.db.query(table,
          columns: Category.columns,
          where: "lvl = ?",
          orderBy: "position",
          whereArgs: [lvl]);
      await client.close();
      cacheByLevel[lvl] = results.map<Category>(Category.fromMap).toList();
    }
    return cacheByLevel[lvl];
  }

  Future<List<Category>> forParentRecursive(int id) async {
    var list = await _forParent(id);

    for (var category in list) {
      category.childs = await forParentRecursive(category.id);
    }

    return list;
  }

  Future<bool> changeSave(Category data) async {
    try {
      await client.open(readonly: false);
      data.isSaved = !data.isSaved;
      await client.db.update(table, data.toMap(),  where: "${Category.columns[0]} = ?", whereArgs: [data.id]);
      await client.close();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> setCurrentTopCategory(int data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('category_top_saved', data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> currentTopCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('category_top_saved') ?? 0;
  }
}
