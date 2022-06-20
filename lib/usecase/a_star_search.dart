import 'dart:collection';

import 'package:kadai/model/puzzle_board.dart';
import 'package:kadai/usecase/search_status.dart';

class AStarSearch {
  final PuzzleBoard start;
  final PuzzleBoard goal;
  final openList = <PuzzleBoard>[];
  final closeMap = HashMap<int, int>();
  final int Function(
    PuzzleBoard currentBoard,
    PuzzleBoard goal,
  ) estimatedCostToGoal;
  PuzzleBoard? result;

  var steps = 0;
  var status = SearchStatus.searching;

  AStarSearch(this.start, this.goal, this.estimatedCostToGoal) {
    start.cost = start.depth + estimatedCostToGoal(start, goal);
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
      // if ((steps % 100) == 0) {
      //   print(
      //       'steps: $steps, depth: ${openList.last.depth}, list length: ${openList.length}');
      // }
    }
  }

  void singleSearchIteration() {
    steps++;
    // openリストが空だったら探索自体を終了
    if (openList.isEmpty) {
      status = SearchStatus.fail;
      return;
    }

    // openリストから最小要素を取得。
    // openリストは小さいものが後に来るように並べ替えられているものとする。
    final focused = openList.removeLast();

    // ゴールだったら探索自体を終了
    if (focused == goal) {
      status = SearchStatus.success;
      result = focused;
      return;
    }

    final addList = <PuzzleBoard>[];

    // 注目してる要素から子ノードを抽出
    for (var childGrid in focused.moveCandidate) {
      final board = focused.moveEmptyTo(childGrid);
      board.cost = board.depth + estimatedCostToGoal(board, goal);

      // closedに入ってるものは無視
      if (closeMap[board.hashCode] != null) {
        if (board.cost < closeMap[board.hashCode]!) {
          closeMap.remove(board.hashCode);
          addList.add(board);
        }
      } else {
        // 入っておらず条件満たしてたらopenListの中身を置き換え
        final sameBoardIndex = openList.indexOf(board);
        if (sameBoardIndex != -1) {
          openList[sameBoardIndex] =
              (openList[sameBoardIndex].cost < board.cost)
                  ? openList[sameBoardIndex]
                  : board;
        } else {
          addList.add(board);
        }
      }
    }

    // 注目してる要素をclosedに追加
    closeMap[focused.hashCode] = focused.cost;

    for (final boardToAdd in addList) {
      final insertIndex = openList
          .lastIndexWhere(((element) => element.cost == boardToAdd.cost));
      if (insertIndex != -1) {
        openList.insert(insertIndex + 1, boardToAdd);
      } else if (openList.isEmpty || boardToAdd.cost < openList.last.cost) {
        openList.add(boardToAdd);
      } else {
        openList.insert(0, boardToAdd);
      }
    }
  }
}
