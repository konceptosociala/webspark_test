import 'package:webspark_test/model/index.dart';

export 'dialog.dart';
export '../widgets/pathfinder.dart';

String pathToString(List<Cell> path) {
  String s = "";

  for (final cell in path) {
    s += "(${cell.x};${cell.y})->";
  }

  s = s.replaceAll(RegExp(r'\-\>$'), '');

  return s;
}