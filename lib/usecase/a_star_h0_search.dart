import 'dart:collection';

import 'package:kadai/model/puzzle_board.dart';
import 'package:kadai/usecase/search_status.dart';

class AStarH0Search {
  final PuzzleBoard start;
  final PuzzleBoard goal;
  var openList = <PuzzleBoard>[];
  var nextOpenList = <PuzzleBoard>[];
  final closeMap = HashMap<int, int>();
  PuzzleBoard? result;

  var steps = 0;
  var status = SearchStatus.searching;

  AStarH0Search(this.start, this.goal) {
    start.cost = start.depth;
    openList.add(start);
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
          return;
      }
    }
  }

  void singleSearchIteration() {
    steps++;
    // openリスト、nextOpenListが空だったら探索自体を終了
    if (openList.isEmpty) {
      if (nextOpenList.isEmpty) {
        status = SearchStatus.fail;
        return;
      } else {
        openList = [...nextOpenList];
        nextOpenList.clear();
        return;
      }
    }

    // openリストから最小要素を取得。
    final focused = openList.removeLast();

    // ゴールだったら探索自体を終了
    if (focused == goal) {
      status = SearchStatus.success;
      result = focused;
      return;
    }

    // 注目してる要素から子ノードを抽出
    for (var childGrid in focused.moveCandidate) {
      final board = focused.moveEmptyTo(childGrid);
      if (closeMap[board.hashCode] != null) {
        // 何もしない
      } else {
        nextOpenList.add(board);
      }
    }

    // 注目してる要素をclosedに追加
    closeMap[focused.hashCode] = focused.cost;
  }
}
