// import 'package:dertos_inferno_app/game/logic.dart';
// import 'package:flutter_test/flutter_test.dart';

import 'package:dertos_inferno_app/game/logic.dart';
import 'package:tuple/tuple.dart';

void main() {
  // const names = ["Kostas", "Dertos", "Giannos", "Mhtsos", "Eggelos", "Morfeas"];
  final board = Board([
    const Tuple2(30, 20),
    const Tuple2(20, 10),
    const Tuple2(20, 10),
    const Tuple2(20, 10),
    const Tuple2(20, 10),
  ]);
  print(board);
  // print(board.levels[1].main);
  // print("--------");
  // print(board.levels[1].alternative);
}
