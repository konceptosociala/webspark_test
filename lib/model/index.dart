import 'package:webspark_test/model/index.dart';

export 'grid.dart';
export 'cell.dart';
export 'dotx.dart';

class Data {
  final Cell start;
  final Cell end;
  final Grid grid;

  Data({
    required this.start, 
    required this.end, 
    required this.grid,
  });

  factory Data.fromJson(Map<String, dynamic> json) {   
    return switch (json) {
      {
        'id': String _,
        'field': List<dynamic> grid,
        'start': Map<String, dynamic> start,
        'end': Map<String, dynamic> end,
      } => Data(
        start: Cell.fromJson(start),
        end: Cell.fromJson(end),
        grid: Grid.fromDotX(
          grid
            .cast<String>()
            .map((e) => DotX(e))
            .toList()
        ),
      ),
      _ => throw const FormatException("Failed to load data"),
    };
  }
}