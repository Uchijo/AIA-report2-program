import 'package:kadai/model/Stack.dart';
import 'package:kadai/model/puzzle_board.dart';
import 'package:kadai/usecase/search_status.dart';

class IterativeDeepeningSearch {
  final PuzzleBoard start;
  final PuzzleBoard goal;
  final openStack = Stack<PuzzleBoard>();
  final closeSet = <int>{};
  final int initialDepthLimit;
  late int _depthLimit;
  final int Function(int previousDepth) deepeningStrategy;
  var deepened = 0;
  var steps = 0;
  var status = SearchStatus.searching;
  var touchedLimit = false;

  IterativeDeepeningSearch(
      {required this.goal,
      required this.start,
      required this.initialDepthLimit,
      required this.deepeningStrategy}) {
    _depthLimit = initialDepthLimit;
    openStack.push(start);
  }

  void initState() {
    status = SearchStatus.searching;
    openStack.clear();
    openStack.push(start);
    closeSet.clear();
    touchedLimit = false;
  }

  void run() {
    for (;;) {
      singleSearchIteration();

      switch (status) {
        case SearchStatus.searching:
          break;
        case SearchStatus.success:
          return;
        case SearchStatus.fail:
          if (touchedLimit) {
            // 深さを変えて再度最初から
            initState();
            _depthLimit = deepeningStrategy(_depthLimit);
            deepened++;
          } else {
            print('not found.');
            return;
          }
      }
    }
  }

  // スタックの先頭に対して深さ優先探索のアレを行う
  void singleSearchIteration() {
    steps++;
    // スタックの先頭がnullだったら失敗として処理全体を終了
    if (openStack.peek == null) {
      status = SearchStatus.fail;
      return;
    }

    final focusedBoard = openStack.peek!;

    // 注目している要素がゴールなら成功として処理全体を終了
    if (focusedBoard == goal) {
      status = SearchStatus.success;
      return;
    }

    // 注目している要素の深さが制限に引っかかるならポップして終了
    if (focusedBoard.depth >= _depthLimit) {
      touchedLimit = true;
      openStack.pop();
      return;
    }

    // 注目している要素を確認し、走査済みであればポップして終了
    if (closeSet.contains(focusedBoard.hashCode)) {
      openStack.pop();
      return;
    }

    // closeSetに先頭を追加
    closeSet.add(focusedBoard.hashCode);

    // 対象の要素から子ノードを生成
    final childrenGrid = focusedBoard.moveCandidate;
    final childrenBoards = childrenGrid
        .map((candidateGrid) => focusedBoard.moveEmptyTo(candidateGrid))
        .toList();

    for (final childBoard in childrenBoards) {
      // ゴールだったら成功として探索全体を終了
      if (childBoard == goal) {
        status = SearchStatus.success;
        return;
      }

      // closeSetにないものはスタックに追加
      if (closeSet.contains(childBoard.hashCode)) {
        // do nothing
      } else {
        openStack.push(childBoard);
      }
    }
  }
}
