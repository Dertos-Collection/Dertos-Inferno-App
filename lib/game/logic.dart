import 'dart:math';

import 'package:dertos_inferno_app/error.dart';
import 'package:tuple/tuple.dart';

class Tile {
  static var nextId = 0;
  Tuple2<Tile, Tile?>? backwards;
  Tuple2<Tile, Tile?>? forwards;
  final int level;
  final int id;

  Tile.raw({this.backwards, this.forwards, required this.level})
      : id = nextId++;
  Tile.forwardFork(this.forwards, this.level, [Tile? previous])
      : backwards = ((previous != null) ? Tuple2(previous, null) : null),
        id = nextId++;
  Tile.backwardFork(this.backwards, this.level, [Tile? previous])
      : forwards = ((previous != null) ? Tuple2(previous, null) : null),
        id = nextId++;
  Tile(this.level, {Tile? previous, Tile? next})
      : backwards = previous != null ? Tuple2(previous, null) : null,
        forwards = next != null ? Tuple2(next, null) : null,
        id = nextId++;

  Tile? get nextLeft => forwards?.item1;
  Tile? get nextRight => forwards?.item2;
  Tile? get previousLeft => backwards?.item1;
  Tile? get previousRight => backwards?.item2;

  bool get isStart => backwards == null;
  bool get isForwardFork => forwards?.item2 != null;
  bool get isBackwardFork => backwards?.item2 != null;
  bool get isSimple =>
      backwards != null &&
      forwards != null &&
      forwards!.item2 == null &&
      backwards!.item2 == null;
  bool get isEnd => forwards == null;

  int get backwardsEdgeCount =>
      (backwards != null) ? 1 + ((backwards!.item2 != null) ? 1 : 0) : 0;
  int get forwardsEdgeCount =>
      (forwards != null) ? 1 + ((forwards!.item2 != null) ? 1 : 0) : 0;

  @override
  String toString() {
    String common =
        "Tile($id, level: $level, with $backwardsEdgeCount backwards and $forwardsEdgeCount forwards)";
    if (isStart) {
      common = "Starting $common";
    }
    if (isEnd) {
      common = "Ending $common";
    }
    if (isForwardFork) {
      common = "Forward fork $common";
    }
    if (isBackwardFork) {
      common = "Backward fork $common";
    }
    if (isSimple) {
      common = "Simple $common";
    }
    return common;
  }
}

enum Direction { left, right }

class Player {
  static var nextId = 0;
  final String name;
  final int id;
  Tile position;
  Player(this.name, this.position) : id = nextId++;

  /// Advances the player to the next tile (no checking is done)
  void advance({Direction direction = Direction.left}) {
    if (position.isEnd) {
      throw InternalError(
          "advance() called on player $name who is at the end of the board");
    }
    position =
        direction == Direction.left ? position.nextLeft! : position.nextRight!;
  }

  /// Retreats the player to the previous tile (no checking is done)
  void retreat({Direction direction = Direction.left}) {
    if (position.isStart) {
      throw InternalError(
          "retreat() called on player $name who is at the start of the board");
    }
    position = direction == Direction.left
        ? position.previousLeft!
        : position.previousRight!;
  }

  @override
  String toString() {
    return "Player(name: $name, position: $position)";
  }
}

typedef Path = List<Tile>;

class Level extends Tuple2<Path, Path> {
  Level(Path left, Path right) : super(left, right);
  Path get left => item1;
  Path get right => item2;
}

class Board {
  List<Level> levels;
  Board(List<Tuple2<int, int>> levelSizes) : levels = [] {
    Tile? previousLevelEnd;
    for (var levelIndex = 0; levelIndex < levelSizes.length; levelIndex++) {
      final level = levelSizes[levelIndex];
      final currentLevelStart = () {
        if (previousLevelEnd != null) {
          final retval = Tile(levelIndex, previous: previousLevelEnd);
          previousLevelEnd.forwards = Tuple2(retval, null);
          return retval;
        } else {
          return Tile(levelIndex);
        }
      }();
      final currentLevelEnd = Tile(levelIndex);
      final leftPath = makePath(
          currentLevelStart, currentLevelEnd, level.item1 - 2, levelIndex);
      final rightPath = makePath(
          currentLevelStart, currentLevelEnd, level.item2 - 2, levelIndex);
      previousLevelEnd = currentLevelEnd;
      levels.add(Level(leftPath, rightPath));
    }
  }

  List<Tile> getNNearRandoms(int N, [int levelIndex = 1]) {
    final level = levels[levelIndex];
    final leftPath = level.left;
    final rightPath = level.right;
    final rng = Random();

    return List.generate(N, (_) {
      final leftIndex = rng.nextInt(leftPath.length);
      final rightIndex = rng.nextInt(rightPath.length);
      return rng.nextBool() ? leftPath[leftIndex] : rightPath[rightIndex];
    });
  }

  static Path makePath(Tile start, Tile end, int length, int level) {
    final path = List.generate(length, (_) => Tile(level));
    for (int i = 0; i < length - 1; i++) {
      path[i].forwards = Tuple2(path[i + 1], null);
      path[i + 1].backwards = Tuple2(path[i], null);
    }
    start.forwards =
        start.forwards?.withItem2(path.first) ?? Tuple2(path.first, null);
    path.first.backwards = Tuple2(start, null);
    end.backwards =
        end.backwards?.withItem2(path.last) ?? Tuple2(path.last, null);
    path.last.forwards = Tuple2(end, null);
    return [start, ...path, end];
  }

  @override
  String toString() {
    return "Board(levels: $levels)";
  }
}

class GameState {
  final Board board;
  late Map<String, Player> players;
  // Game(this.board, this.players);
  GameState.general(List<Tuple2<int, int>> levels, List<String> playerNames)
      : board = Board(levels) {
    final positions = board.getNNearRandoms(playerNames.length);
    final mapEntries = List.generate(playerNames.length,
        (i) => MapEntry(playerNames[i], Player(playerNames[i], positions[i])));
    players = Map.fromEntries(mapEntries);
  }
  GameState(List<String> playerNames)
      : this.general([
          const Tuple2(30, 20),
          const Tuple2(20, 15),
          const Tuple2(20, 15),
          const Tuple2(20, 15),
          const Tuple2(20, 15)
        ], playerNames);

  @override
  String toString() {
    return "GameState(board: $board, players: $players)";
  }
}
