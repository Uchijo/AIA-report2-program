import 'package:kadai/model/puzzle_board.dart';
import 'package:kadai/usecase/a_star_h0_search.dart';
import 'package:kadai/usecase/a_star_search.dart';
import 'package:kadai/usecase/iterative_deepening_search.dart';

void main(List<String> args) {
  var count = 0;
  final goal = PuzzleBoard(
    [
      [1, 2, 3],
      [8, 0, 4],
      [7, 6, 5],
    ],
    depth: 0,
  );
  var result = '';

  // final start = PuzzleBoard([
    // [5, 7, 8],
    // [3, 4, 0],
    // [2, 6, 1],
  // ], depth: 0);

  // final elementList = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  // var counter = 0;
  // for (final value in elementList) {
    // final currentGrid = start.findGridByValue(value);
    // final goalGrid = goal.findGridByValue(value);
    // counter +=
        // (currentGrid.x - goalGrid.x).abs() + (currentGrid.x - goalGrid.x).abs();
  // }
  // print(counter);

  while (count < 100) {
    final start = PuzzleBoard.random();
    if (start.canSolve(goal)) {
      result += trial(start, goal);
      result += '\n';
      count++;
      print('');
      print('count: $count. current result:');
      print(result);
      print('');
    }
  }
}

String trial(PuzzleBoard start, PuzzleBoard goal) {
  final piyo = IterativeDeepeningSearch(
    start: start,
    goal: goal,
    initialDepthLimit: 5,
    deepeningStrategy: (fuga) {
      print('new limit: ${fuga + 5}');
      return fuga + 5;
    },
  );
  final h0 = AStarH0Search(start, goal);

  final h1 = AStarSearch(start, goal, ((currentBoard, goal) {
    final currentVector = currentBoard.gridVector;
    final goalVector = goal.gridVector;
    var count = 0;
    for (int i = 0; i < currentVector.length; i++) {
      if (currentVector[i] != goalVector[i]) {
        count++;
      }
    }
    return count;
  }));

  final h2 = AStarSearch(start, goal, ((currentBoard, goal) {
    final elementList = [0, 1, 2, 3, 4, 5, 6, 7, 8];
    var count = 0;
    for (final value in elementList) {
      final currentGrid = currentBoard.findGridByValue(value);
      final goalGrid = goal.findGridByValue(value);
      count += (currentGrid.x - goalGrid.x).abs() +
          (currentGrid.x - goalGrid.x).abs();
    }
    return count;
  }));

  piyo.run();
  print('ids depth: ${piyo.openStack.peek?.depth}, steps: ${piyo.steps}');

  h0.run();
  print('h0 depth: ${h0.result?.depth}, steps: ${h0.steps}');

  h1.run();
  print('h1 depth: ${h1.result?.depth}, steps: ${h1.steps}');

  h2.run();
  print('h2 depth: ${h2.result?.depth}, steps: ${h2.steps}');

  return ('${piyo.openStack.peek?.depth}, ${piyo.steps}, ${h0.result?.depth}, ${h0.steps}, ${h1.result?.depth}, ${h1.steps}, ${h2.result?.depth}, ${h2.steps}');
}

void printStack(PuzzleBoard? child) {
  if (child != null) {
    print(child.content);
    printStack(child.parent);
  }
}
