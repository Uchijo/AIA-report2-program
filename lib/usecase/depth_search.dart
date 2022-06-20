import 'package:kadai/model/Stack.dart';
import 'package:kadai/model/puzzle_board.dart';
import 'package:kadai/usecase/search_status.dart';

class DepthSearch {
  final PuzzleBoard start;
  final PuzzleBoard goal;
  final openStack = Stack<PuzzleBoard>();
  final closeSet = <int>{};
  var status = SearchStatus.searching;

  DepthSearch({required this.goal, required this.start}) {
    openStack.push(start);
  }

  void run() {
    for (;;) {
      singleSearchIteration();

      switch (status) {
        case SearchStatus.searching:
          break;
        case SearchStatus.success:
          print('found.');
          print('depth: ${openStack.peek?.depth}');
          return;
        case SearchStatus.fail:
          print('not found.');
          return;
      }
    }
  }

  // スタックの先頭に対して深さ優先探索のアレを行う
  void singleSearchIteration() {
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
