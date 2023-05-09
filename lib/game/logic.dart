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
    return
        // "*****Level $depth*****\n"
        "${'{:<10}'.format(' ')}"
            "${"{:<5} ╔{}╗\n".format([" ", mainStr])}" // line one
            "${"Level {:<2}: {}═╣{}╠═{}\n".format([
          depth,
          "{:>5}".format(start.id),
          List.generate(mainStr.length, (_) => " ").join(""),
          "{:<5}".format(end.id)
        ])}" // line two
            "${'{:<10}'.format(' ')}"
            "${"{:<5} ╚{}╝\n".format([" ", alternativeStr])}"; // line three
    // "*****Level $depth end*****\n";
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

class GameState {
  final Board board;
  late final Map<String, Player> players;
  GameState.general(List<Tuple2<int, int>> levelSizes, List<String> playerNames)
      : board = Board(levelSizes) {
    final playerStartingPositions =
        genRandomPositions(playerNames.length, board);
    final playerEntries = List.generate(
        playerNames.length,
        (index) => MapEntry(playerNames[index],
            Player(playerNames[index], playerStartingPositions[index])));
    players = Map.fromEntries(playerEntries);
  }
  GameState(List<String> playerNames)
      : this.general([
          const Tuple2(30, 20),
          const Tuple2(20, 15),
          const Tuple2(20, 15),
          const Tuple2(20, 15),
          const Tuple2(20, 15),
        ], playerNames);

  static List<Tile> genRandomPositions(int n, Board board,
      [int levelIndex = 1]) {
    final rng = Random();
    final level = board.levels[levelIndex];
    final allLevelTiles =
        level.main + level.alternative.sublist(1, level.alternative.length - 1);
    return List.generate(
        n, (index) => allLevelTiles[rng.nextInt(allLevelTiles.length)]);
  }

  @override
  String toString() {
    return "Board:\n"
        "$board\n"
        "Players:\n"
        "${players.values.map((e) => '${e.name} is at ${e.position.id}').join("\n")}";
  }
}
