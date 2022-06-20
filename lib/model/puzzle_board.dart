import 'dart:math';

import 'package:kadai/model/grid.dart';

// 縦がx, 横がy. grid[x][y]
// 座標は0始まり。よって取る値は0,1,2の3種
class PuzzleBoard {
  final List<List<int>> grid;
  late final Grid emptyGrid;
  late final PuzzleBoard? parent;
  final int depth;
  int cost = 0;

  List<int> get gridVector => [...grid[0], ...grid[1], ...grid[2]];

  String content = '';

  List<Grid> get moveCandidate => emptyGrid.findCandidate();

  PuzzleBoard(this.grid, {Grid? emptyGrid, this.parent, required this.depth}) {
    if (emptyGrid != null) {
      this.emptyGrid = emptyGrid;
    } else {
      this.emptyGrid = _findEmptySpot();
    }
    content = '';
    for (int i = 0; i < 3; i++) {
      content += "${grid[i][0]} ${grid[i][1]} ${grid[i][2]} | ";
    }
  }

  factory PuzzleBoard.random() {
    final valuePool = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    valuePool.shuffle();
    return PuzzleBoard(
      [
        valuePool.getRange(0, 3).toList(),
        valuePool.getRange(3, 6).toList(),
        valuePool.getRange(6, 9).toList(),
      ],
      depth: 0,
    );
  }
  // for debug
  void printGrid() {
    for (int i = 0; i < 3; i++) {
      print("${grid[i][0]} ${grid[i][1]} ${grid[i][2]}");
    }
  }

  Grid _findEmptySpot() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i][j] == 0) {
          return Grid(x: i, y: j);
        }
      }
    }
    throw Exception('empty grid not found');
  }

  Grid findGridByValue(int elem) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i][j] == elem) {
          return Grid(x: i, y: j);
        }
      }
    }
    throw Exception('not found');
  }

  int getValueByGrid(Grid target) {
    return grid[target.x][target.y];
  }

  PuzzleBoard moveEmptyTo(Grid destination) {
    int previousDestinationValue = getValueByGrid(destination);
    var newGrid = [
      [...grid[0]],
      [...grid[1]],
      [...grid[2]],
    ];
    newGrid[emptyGrid.x][emptyGrid.y] = newGrid[destination.x][destination.y];
    newGrid[destination.x][destination.y] = 0;
    return PuzzleBoard(newGrid, parent: this, depth: depth + 1);
  }

  bool canSolve(PuzzleBoard goal) {
    final goalVector = goal.gridVector;
    final selfVector = [...gridVector];

    final goalDistance = (goal.emptyGrid.x - emptyGrid.x).abs() +
        (goal.emptyGrid.y - emptyGrid.y).abs();

    int swapNum = 0;

    for (int i = 0; i < selfVector.length; i++) {
      if (selfVector[i] == goalVector[i]) {
        continue;
      }

      final swapIndex =
          selfVector.indexWhere((element) => element == goalVector[i]);
      final temp = selfVector[i];
      selfVector[i] = selfVector[swapIndex];
      selfVector[swapIndex] = temp;
      swapNum++;
    }

    return ((goalDistance - swapNum) % 2) == 0;
  }

  // グリッド上の配置が同じだったら同じオブジェクトとして扱うように == と hashCodeを書き換え
  @override
  int get hashCode => calculateHash();

  int calculateHash() {
    int sum = 0;
    int count = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        sum += pow(10, count++).toInt() * grid[i][j];
      }
    }

    return sum;
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  String toString() {
    return content;
  }
}
