import 'dart:async';

class BottomNavigationBloc {
  final _indexController = StreamController<int>.broadcast();
  Stream<int> get indexStream => _indexController.stream;

  void dispose() {
    _indexController.close();
  }

  void setIndex(int index) {
    _indexController.sink.add(index);
  }
}
