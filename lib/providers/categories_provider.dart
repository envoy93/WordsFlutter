import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db.dart';

class CategoriesProvider {
  final DatabaseClient client;
  final String table = "categories";
  final Map<int, List<Category>> cacheByParent = new Map();
  final Map<int, List<Category>> cacheByLevel = new Map();

  CategoriesProvider(this.client);

  Future init() async {
    await forLevel(0);
  }

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

  List<Category> forTopLevel() {
    return cacheByLevel[0] ?? List();
  }

  Future<List<Category>> forLevel(int id) async {
    if (!cacheByLevel.containsKey(id)) {
      await client.open();
      List<Map> results = await client.db.query(table,
          columns: Category.columns,
          where: "lvl = ?",
          orderBy: "position",
          whereArgs: [id]);
      await client.close();
      cacheByLevel[id] = results.map<Category>(Category.fromMap).toList();
    }
    return cacheByLevel[id];
  }

  Future<List<Category>> forParentRecursive(int id) async {
    var list = await _forParent(id);

    for (var category in list) {
      category.childs = await forParentRecursive(category.id);
    }

    return list;
  }

  Future changeSave(Category data) async {
    data.isSaved = !data.isSaved; //TODO save to db
  }
}
