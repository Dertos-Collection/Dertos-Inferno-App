import 'dart:math';

import 'package:dertos_inferno_app/error.dart';
import 'package:format/format.dart';
import 'package:tuple/tuple.dart';

enum Direction { forwards, backwards }

// enum PathCoice { main, alternative }

class Neighbours extends Tuple2<Tile, Tile?> {
  Neighbours(Tile main, [Tile? other]) : super(main, other);
  Tile get main => item1;
  Tile? get other => item2;
}

class Tile {
  static int nextId = 0;
  final int id = nextId++;
  Neighbours? backwards;
  Neighbours? forwards;
  final int level;
  Neighbours? getNeighbours(Direction d) {
    switch (d) {
      case Direction.forwards:
        return forwards;
      case Direction.backwards:
        return backwards;
    }
  }

  void setNeighbours(Direction d, Neighbours n) {
    switch (d) {
      case Direction.forwards:
        forwards = n;
        break;
      case Direction.backwards:
        backwards = n;
        break;
    }
  }

  Tile(this.level, {this.backwards, this.forwards});

  void addNeighbour(Tile neighbour, Direction d) {
    if (getNeighbours(d) == null) {
      setNeighbours(d, Neighbours(neighbour));
      return;
    }
    if (getNeighbours(d)!.other != null) {
      throw InternalError("Tried to add a third $d neighbour to tile $id");
    }
    setNeighbours(d, Neighbours(getNeighbours(d)!.main, neighbour));
  }
}

class Player {
  static int nextId = 0;
  final int id = nextId++;
  final String name;

  Tile position;
  int points = 0;

  Player(this.name, this.position);
}

typedef Path = List<Tile>;

// class Path extends List<Tile> {
//   Path()
// }
extension PathPrinter on Path {
  String formatAsPath() {
    return map((e) => e.id.toString()).join("═");
  }
}

class Level extends Tuple2<Path, Path> {
  final int depth;
  Level(Path main, Path alternative, this.depth) : super(main, alternative);
  Path get main => item1;
  Path get alternative => item2;
  Tile get start => main.first;
  Tile get end => main.last;

  @override
  String toString() {
    final mainStr = main.sublist(1, main.length - 1).formatAsPath();
    String alternativeStr =
        alternative.sublist(1, alternative.length - 1).formatAsPath();
    final difference = mainStr.length - alternativeStr.length;
    final leftPad = (difference / 2).round();
    final rightPad = difference - leftPad;
    alternativeStr = List.generate(leftPad.round(), (_) => "═").join("") +
        alternativeStr +
        List.generate(rightPad.round(), (_) => "═").join("");
    String firstLine = "*****Level $depth*****\n";
    String secondLine = "{:<5}╔{}╗\n".format([" ", mainStr]);
    String thirdLine = "{}╣{}╠{}\n".format([
      "{:>5}".format(start.id),
      List.generate(mainStr.length, (_) => " ").join(""),
      "{:<5}".format(end.id)
    ]);
    String fourthLine = "{:<5}╚{}╝\n".format([" ", alternativeStr]);
    String fifthLine = "*****Level $depth end*****\n";
    return firstLine + secondLine + thirdLine + fourthLine + fifthLine;
  }
}

class Board {
  final List<Level> levels;
  Board(List<Tuple2<int, int>> levelSizes) : levels = [] {
    for (int i = 0; i < levelSizes.length; i++) {
      levels.add(makeLevel(levelSizes[i], i));
    }
    for (int i = 0; i < levels.length - 1; i++) {
      levels[i].end.addNeighbour(levels[i + 1].start, Direction.forwards);
      levels[i + 1].start.addNeighbour(levels[i].end, Direction.backwards);
    }
  }

  static Level makeLevel(Tuple2<int, int> pathSizes, int level) {
    final levelEntry = Tile(level);
    final mainPath = makePath(pathSizes.item1 - 2, level);
    final alternativePath = makePath(pathSizes.item2 - 2, level);
    final levelExit = Tile(level);
    for (final tile in [mainPath.first, alternativePath.first]) {
      tile.addNeighbour(levelEntry, Direction.backwards);
      levelEntry.addNeighbour(tile, Direction.forwards);
    }
    for (final tile in [mainPath.last, alternativePath.last]) {
      tile.addNeighbour(levelExit, Direction.forwards);
      levelExit.addNeighbour(tile, Direction.backwards);
    }
    return Level([levelEntry, ...mainPath, levelExit],
        [levelEntry, ...alternativePath, levelExit], level);
  }

  static Path makePath(int length, int level) {
    final path = List.generate(length, (index) => Tile(level));
    for (var i = 0; i < length - 1; i++) {
      path[i].addNeighbour(path[i + 1], Direction.forwards);
      path[i + 1].addNeighbour(path[i], Direction.backwards);
    }
    return path;
  }

  @override
  String toString() {
    return levels.map((e) => e.toString()).join("");
  }
}

// class GameState {
//   final Board board;
//   final List<Player> players;
// }

// class Tile {
//   static var nextId = 0;
//   Tuple2<Tile, Tile?>? backwards;
//   Tuple2<Tile, Tile?>? forwards;
//   final int level;
//   final int id = nextId++;

//   Tile.raw({this.backwards, this.forwards, required this.level});
//   Tile.forwardFork(this.forwards, this.level, [Tile? previous])
//       : backwards = ((previous != null) ? Tuple2(previous, null) : null);
//   Tile.backwardFork(this.backwards, this.level, [Tile? previous])
//       : forwards = ((previous != null) ? Tuple2(previous, null) : null);
//   Tile(this.level, {Tile? previous, Tile? next})
//       : backwards = previous != null ? Tuple2(previous, null) : null,
//         forwards = next != null ? Tuple2(next, null) : null;

//   Tile? get nextLeft => forwards?.item1;
//   Tile? get nextRight => forwards?.item2;
//   Tile? get previousLeft => backwards?.item1;
//   Tile? get previousRight => backwards?.item2;

//   bool get isStart => backwards == null;
//   bool get isForwardFork => forwards?.item2 != null;
//   bool get isBackwardFork => backwards?.item2 != null;
//   bool get isSimple =>
//       backwards != null &&
//       forwards != null &&
//       forwards!.item2 == null &&
//       backwards!.item2 == null;
//   bool get isEnd => forwards == null;

//   int get backwardsEdgeCount =>
//       (backwards != null) ? 1 + ((backwards!.item2 != null) ? 1 : 0) : 0;
//   int get forwardsEdgeCount =>
//       (forwards != null) ? 1 + ((forwards!.item2 != null) ? 1 : 0) : 0;

//   @override
//   String toString() {
//     String common =
//         "Tile($id, level: $level, with $backwardsEdgeCount backwards and $forwardsEdgeCount forwards)";
//     if (isStart) {
//       common = "Starting $common";
//     }
//     if (isEnd) {
//       common = "Ending $common";
//     }
//     if (isForwardFork) {
//       common = "Forward fork $common";
//     }
//     if (isBackwardFork) {
//       common = "Backward fork $common";
//     }
//     if (isSimple) {
//       common = "Simple $common";
//     }
//     return common;
//   }
// }

// enum Direction { left, right }

// class Player {
//   static var nextId = 0;
//   final String name;
//   final int id = nextId++;
//   Tile position;
//   Player(this.name, this.position);

//   /// Advances the player to the next tile (no checking is done)
//   void advance({Direction direction = Direction.left}) {
//     if (position.isEnd) {
//       throw InternalError(
//           "advance() called on player $name who is at the end of the board");
//     }
//     position =
//         direction == Direction.left ? position.nextLeft! : position.nextRight!;
//   }

//   /// Retreats the player to the previous tile (no checking is done)
//   void retreat({Direction direction = Direction.left}) {
//     if (position.isStart) {
//       throw InternalError(
//           "retreat() called on player $name who is at the start of the board");
//     }
//     position = direction == Direction.left
//         ? position.previousLeft!
//         : position.previousRight!;
//   }

//   @override
//   String toString() {
//     return "Player(name: $name, position: $position)";
//   }
// }

// typedef Path = List<Tile>;

// class Level extends Tuple2<Path, Path> {
//   Level(Path left, Path right) : super(left, right);
//   Path get left => item1;
//   Path get right => item2;
// }

// class Board {
//   List<Level> levels;
//   Board(List<Tuple2<int, int>> levelSizes) : levels = [] {
//     Tile? previousLevelEnd;
//     for (var levelIndex = 0; levelIndex < levelSizes.length; levelIndex++) {
//       final level = levelSizes[levelIndex];
//       final currentLevelStart = () {
//         if (previousLevelEnd != null) {
//           final retval = Tile(levelIndex, previous: previousLevelEnd);
//           previousLevelEnd.forwards = Tuple2(retval, null);
//           return retval;
//         } else {
//           return Tile(levelIndex);
//         }
//       }();
//       final currentLevelEnd = Tile(levelIndex);
//       final leftPath = makePath(
//           currentLevelStart, currentLevelEnd, level.item1 - 2, levelIndex);
//       final rightPath = makePath(
//           currentLevelStart, currentLevelEnd, level.item2 - 2, levelIndex);
//       previousLevelEnd = currentLevelEnd;
//       levels.add(Level(leftPath, rightPath));
//     }
//   }

//   List<Tile> getNNearRandoms(int N, [int levelIndex = 1]) {
//     final rng = Random();
//     final level = levels[levelIndex];
//     final leftPath = level.left;
//     final rightPath = level.right;

//     return List.generate(N, (_) {
//       final leftIndex = rng.nextInt(leftPath.length);
//       final rightIndex = rng.nextInt(rightPath.length);
//       return rng.nextBool() ? leftPath[leftIndex] : rightPath[rightIndex];
//     });
//   }

//   static Path makePath(Tile start, Tile end, int length, int level) {
//     final path = List.generate(length, (_) => Tile(level));
//     for (int i = 0; i < length - 1; i++) {
//       path[i].forwards = Tuple2(path[i + 1], null);
//       path[i + 1].backwards = Tuple2(path[i], null);
//     }
//     start.forwards =
//         start.forwards?.withItem2(path.first) ?? Tuple2(path.first, null);
//     path.first.backwards = Tuple2(start, null);
//     end.backwards =
//         end.backwards?.withItem2(path.last) ?? Tuple2(path.last, null);
//     path.last.forwards = Tuple2(end, null);
//     return [start, ...path, end];
//   }

//   @override
//   String toString() {
//     return "Board(levels: $levels)";
//   }
// }

// class GameState {
//   final Board board;
//   late final Map<String, Player> players;
//   // Game(this.board, this.players);
//   GameState.general(List<Tuple2<int, int>> levels, List<String> playerNames)
//       : board = Board(levels) {
//     final positions = board.getNNearRandoms(playerNames.length);
//     final mapEntries = List.generate(playerNames.length,
//         (i) => MapEntry(playerNames[i], Player(playerNames[i], positions[i])));
//     players = Map.fromEntries(mapEntries);
//   }
//   GameState(List<String> playerNames)
//       : this.general([
//           const Tuple2(30, 20),
//           const Tuple2(20, 15),
//           const Tuple2(20, 15),
//           const Tuple2(20, 15),
//           const Tuple2(20, 15)
//         ], playerNames);

//   @override
//   String toString() {
//     return "GameState(board: $board, players: $players)";
//   }
// }
