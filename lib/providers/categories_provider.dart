import 'dart:async';
import 'package:hello_world/models/domain.dart';
import 'package:hello_world/providers/db/db.dart';

abstract class ICategoriesProvider {
  Future<List<Category>> forLevel(int lvl);
  Future<List<Category>> forParent(int id);
  Future changeSave(Category data);
}

class CategoriesProvider implements ICategoriesProvider {
  final DatabaseConnection _connection;
  final String _table = "categories";

  CategoriesProvider(this._connection);

  /*Future<Category> forId(int id) async {
    var db = await _connection.db;
    List<Map> results = await db.query(_table,
        columns: Category.columns, where: "id = ?", whereArgs: [id]);
    var res = Category.fromMap(results[0]);
    return res;
  }*/

  Future<List<Category>> _forParent(int id) async {
      var db = await _connection.db;

      return (await db.query(_table,
          columns: Category.columns,
          where: "parent_id = ?",
          orderBy: "position",
          whereArgs: [id])).map<Category>(Category.fromMap).toList();
  }

  Future<List<Category>> forLevel(int lvl) async {
      var db = await _connection.db;

      List<Category> results = (await db.query(_table,
          columns: Category.columns,
          where: "lvl = ?",
          orderBy: "position",
          whereArgs: [lvl])).map<Category>(Category.fromMap).toList();

      for (var category in results) {
        category.childs.addAll(await forParent(category.id));
      }
    
    return results;
  }

  Future<List<Category>> forParent(int id) async {
    var list = await _forParent(id);

    for (var category in list) {
      category.childs.addAll(await forParent(category.id));
    }

    return list;
  }

  Future changeSave(Category data) async {
    var db = await _connection.db;

    data.isSaved = !data.isSaved;
    await db.update(_table, data.toMap(),
        where: "${Category.columns[0]} = ?", whereArgs: [data.id]);
  }
}

class CachedCategoriesProvider implements ICategoriesProvider {
  final ICategoriesProvider _provider;
  final Map<int, List<Category>> _cacheByParent = new Map();
  final Map<int, List<Category>> _cacheByLevel = new Map();

  CachedCategoriesProvider(this._provider);

  Future<List<Category>> forLevel(int lvl) async {
    if (!_cacheByLevel.containsKey(lvl)) {
      _cacheByLevel[lvl] = await _provider.forLevel(lvl); 
      _cacheByLevel[lvl].forEach(_cacheChilds);

    }
    return _cacheByLevel[lvl];
  }

  Future<List<Category>> forParent(int id) async {
    if (!_cacheByParent.containsKey(id)) {
      _cacheByParent[id] = await _provider.forParent(id);
      _cacheByParent[id].forEach(_cacheChilds);
    }
    return _cacheByParent[id];
  }

  void _cacheChilds(Category category) {
    for (var child in category.childs) {
      if (!_cacheByParent.containsKey(child.id)) {
        _cacheByParent[child.id] = child.childs;
        _cacheChilds(child);
      }
    }
  }

  Future changeSave(Category data) async {
    await _provider.changeSave(data);
  }
}
