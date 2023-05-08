import 'package:tuple/tuple.dart';

class Tile {
  List<Tile> backwards;
  List<Tile> forwards;

  Tile(this.backwards, this.forwards);
}

List<Tile> makePath(int length) {
  final path = List.generate(length, (_) => Tile([], []));
  for (int i = 0; i < length - 1; i++) {
    path[i].forwards.add(path[i + 1]);
    path[i + 1].backwards.add(path[i]);
  }
  return path;
}

class Board {
  late Tile upper;
  Board.general(List<Tuple2<int, int>> levels) {
    Tile? previousLevelEnd;
    for (final level in levels) {
      final currentLevelStart = () {
        if (previousLevelEnd != null) {
          return Tile([previousLevelEnd], []);
        } else {
          final retval = Tile([], []);
          upper = retval;
          return retval;
        }
      }();
      final currentLevelEnd = Tile([], []);
      final leftPath = makePath(level.item1 - 2);
      final rightPath = makePath(level.item2 - 2);
      currentLevelStart.forwards.add(leftPath.first);
      currentLevelStart.forwards.add(rightPath.first);
      leftPath.last.forwards.add(currentLevelEnd);
      rightPath.last.forwards.add(currentLevelEnd);
      previousLevelEnd = currentLevelEnd;
    }
  }
  Tile getRandomTile() {
    // TODO: implement
    throw UnimplementedError();
  }

  List<Tile> getNNearRandoms(int N) {
    // TODO: implement
    throw UnimplementedError();
  }
}

class Player {
  final String name;
  // final int id;
  Tile position;

  Player(this.name, this.position);
}

class Game {
  final Board board;
  late Map<String, Player> players;
  // Game(this.board, this.players);
  Game.general(List<Tuple2<int, int>> levels, List<String> playerNames)
      : board = Board.general(levels) {
    final positions = board.getNNearRandoms(playerNames.length);
    final mapEntries = List.generate(playerNames.length,
        (i) => MapEntry(playerNames[i], Player(playerNames[i], positions[i])));
    players = Map.fromEntries(mapEntries);
  }
}

// class Player {}
// class Board {}
// class Game {}
