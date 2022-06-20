class Grid {
  final int x;
  final int y;

  Grid({required this.x, required this.y});

  Grid copyWith({
    int? x,
    int? y,
  }) {
    return Grid(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  List<Grid> findCandidate() {
    final candidateList = <Grid>[];

    switch (y) {
      case 0:
      case 2:
        candidateList.add(copyWith(y: 1));
        break;

      case 1:
        candidateList.add(copyWith(y: 0));
        candidateList.add(copyWith(y: 2));
        break;

      default:
        throw Exception("invalid grid coordinate");
    }

    switch (x) {
      case 0:
      case 2:
        candidateList.add(copyWith(x: 1));
        break;

      case 1:
        candidateList.add(copyWith(x: 0));
        candidateList.add(copyWith(x: 2));
        break;

      default:
        throw Exception("invalid grid coordinate");
    }

    return candidateList;
  }

  @override
  String toString() {
    return "Grid(x: $x, y: $y)";
  }
}
