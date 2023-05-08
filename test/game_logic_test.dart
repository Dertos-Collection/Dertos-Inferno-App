import 'package:dertos_inferno_app/game/logic.dart';
// import 'package:flutter_test/flutter_test.dart';

void main() {
  const names = ["Kostas", "Dertos", "Giannos", "Mhtsos", "Eggelos", "Morfeas"];
  GameState game = GameState(names);
  // print(game);
  // for (final level in game.board.levels) {
  for (var levelIdx = 0; levelIdx < game.board.levels.length; levelIdx++) {
    final level = game.board.levels[levelIdx];
    final leftPath = level.left;
    final rightPath = level.right;

    print("Level ${levelIdx}");
    print("---Left path: ${leftPath}");
    print("---Right path: ${rightPath}");
  }
  // test("Try creating a simple board", () {

  // });
}
