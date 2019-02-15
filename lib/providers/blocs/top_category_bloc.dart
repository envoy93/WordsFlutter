import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hello_world/models/domain.dart';

class TopCategoryBloc {
  final ICategoriesProvider categoriesProvider;
  final IPreferencesProvider preferencesProvider;

  final _topCategories = BehaviorSubject<List<Category>>();
  final _topCategory = BehaviorSubject<int>();
  final _categoriesFetcher = PublishSubject<int>();
  final _categoriesOutput = BehaviorSubject<Map<int, Future<List<Category>>>>();

  TopCategoryBloc({
    @required this.categoriesProvider,
    @required this.preferencesProvider,
  }) {
    _categoriesFetcher.stream
        .transform(_wordsTransformer())
        .pipe(_categoriesOutput);

    _topCategory.listen((id) async {
      if (preferencesProvider.currentTopCategory != id)
        await preferencesProvider.updateCurrentTopCategory(id);
      _categoriesFetcher.sink.add(id);
    });

    selectTopCategory(preferencesProvider.currentTopCategory);
  }
  Observable<int> get topCategory => _topCategory.stream;
  Observable<List<Category>> get topCategories => _topCategories.stream;
  Observable<Map<int, Future<List<Category>>>> get categories =>
      _categoriesOutput.stream;

  Function(int) get selectTopCategory => _topCategory.sink.add;

  fetchTopCategories() async {
    final ids = await categoriesProvider.forLevel(0);
    _topCategories.sink.add(ids);
  }

  _wordsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<List<Category>>> cache, int id, index) {
        cache[id] = categoriesProvider.forParent(id);
        return cache;
      },
      <int, Future<List<Category>>>{},
    );
  }

  dispose() async {
    _topCategories.close();
    _categoriesFetcher.close();
    await _categoriesOutput.drain();
    _categoriesOutput.close();
  }
}

class TopCategoryBlocProvider extends InheritedWidget {
  final TopCategoryBloc bloc;

  TopCategoryBlocProvider({
    Key key,
    Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static TopCategoryBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TopCategoryBlocProvider)
            as TopCategoryBlocProvider)
        .bloc;
  }
}
