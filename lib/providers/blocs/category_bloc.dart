import 'package:hello_world/providers/categories_provider.dart';
import 'package:hello_world/providers/words_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hello_world/models/domain.dart';

class CategoryBloc {
  final IWordsProvider wordsProvider;
  final ICategoriesProvider categoriesProvider;

  final _categories = BehaviorSubject<List<Category>>();
  final _wordsFetcher = PublishSubject<int>();
  final _wordsOutput = BehaviorSubject<Map<int, Future<List<Word>>>>();

  CategoryBloc({
    @required this.wordsProvider,
    @required this.categoriesProvider,
  }) {
    _wordsFetcher.stream.transform(_wordsTransformer()).pipe(_wordsOutput);
  }

  Observable<List<Category>> get categories => _categories.stream;
  Observable<Map<int, Future<List<Word>>>> get words => _wordsOutput.stream;

  Function(int) get fetchWords => _wordsFetcher.sink.add;

  fetchCategories(int parentCategory) async {
    final ids = await categoriesProvider.forParent(parentCategory);
    _categories.sink.add(ids);
  }

  _wordsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<List<Word>>> cache, int id, index) {
        cache[id] = wordsProvider.forCategory(id);
        return cache;
      },
      <int, Future<List<Word>>>{},
    );
  }

  dispose() async {
    _categories.close();
    _wordsFetcher.close();
    await _wordsOutput.drain();
    _wordsOutput.close();
  }
}

class CategoryBlocProvider extends InheritedWidget {
  final CategoryBloc bloc;

  CategoryBlocProvider({
    Key key,
    Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static CategoryBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CategoryBlocProvider)
            as CategoryBlocProvider)
        .bloc;
  }
}
