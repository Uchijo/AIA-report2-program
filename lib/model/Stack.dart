class Stack<T> {
  final _list = <T>[];

  void push(T element) => _list.add(element);

  T? pop() {
    if (_list.isEmpty) {
      return null;
    }
    return _list.removeLast();
  }

  T? get peek => _list.isEmpty ? null : _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() {
    return _list.toString();
  }

  void clear() {
    _list.clear();
  }
}
