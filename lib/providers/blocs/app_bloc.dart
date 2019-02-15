import 'package:hello_world/providers/preferences_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';

class AppBloc {
  final IPreferencesProvider _provider;

  final _topCategory = BehaviorSubject<int>();
  final _fullWordView = BehaviorSubject<bool>();

  Observable<bool> get fullWordView => _fullWordView.stream;
  Observable<int> get topCategory => _topCategory.stream;

  Function(int) get updateTopCategory => _topCategory.sink.add;
  Function(bool) get updateFullWordView => _fullWordView.sink.add;

  AppBloc(this._provider) {
    topCategory.listen((id) {
      _provider.updateCurrentTopCategory(id);
    });

    fullWordView.listen((full) {
      _provider.updateIsFullList(full);
    });

    _topCategory.sink.add(_provider.currentTopCategory);
    _fullWordView.sink.add(_provider.isFullList);
  }

  void dispose() {
    _topCategory.close();
    _fullWordView.close();
  }
}

class AppBlocProvider extends InheritedWidget {
  final AppBloc bloc;

  AppBlocProvider({
    Key key,
    Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AppBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AppBlocProvider)
            as AppBlocProvider)
        .bloc;
  }
}
