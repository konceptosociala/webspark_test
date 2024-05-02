import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:webspark_test/model/index.dart';

class Grid {
  late final HashSet<Cell> cells;

  Grid({required List<Cell> cells}):
    cells = HashSet.from(cells);

  /// Create a grid from ".x" system - list of strings with X-s (for blocked cells) and dots (for non-blocked cells)
  /// Example:
  /// ```
  /// .X.
  /// .X.
  /// ...
  /// ```
  Grid.fromDotX(List<DotX> dotxs) {
    HashSet<Cell> cells = HashSet();

    for (var y = 0; y < dotxs.length; y++) {
      DotX dotx = dotxs[y];
      for (var x = 0; x < dotx.value.length; x++) {
        String char = dotx.value.characters.elementAt(x);
        
        if (char == 'x' || char == 'X') {
          cells.add(Cell(x: x, y: y, blocked: true));
        } else {
          cells.add(Cell(x: x, y: y, blocked: false));
        }
      }
    }

    this.cells = cells;
  }

  Cell? getCell(int x, int y) {
    for (final cell in cells) {
      if (cell.x == x && cell.y == y) {
        return cell;
      }
    }

    return null;
  }

  HashSet<Pair> pairs() {
    HashSet<Pair> pairs = HashSet();

    for (final cell in cells) {
      addNeighbour(pairs, findNeighbour(cell, (-1, -1)));
      addNeighbour(pairs, findNeighbour(cell, (-1, 0)));
      addNeighbour(pairs, findNeighbour(cell, (-1, 1)));
      addNeighbour(pairs, findNeighbour(cell, (1, -1)));
      addNeighbour(pairs, findNeighbour(cell, (1, 0)));
      addNeighbour(pairs, findNeighbour(cell, (1, 1)));
      addNeighbour(pairs, findNeighbour(cell, (0, -1)));
      addNeighbour(pairs, findNeighbour(cell, (0, 1)));
    }

    return pairs;
  }

  List<List<Cell>> pairsRaw() {
    return pairs()
      .map((pair) => [pair.first, pair.second])
      .toList();
  }

  Pair? findNeighbour(Cell cell, (int, int) offset) {
    Cell? checkCell;
    checkCell = getCell(cell.x + offset.$1, cell.y + offset.$2);

    if (checkCell != null && !checkCell.blocked && !cell.blocked) {
      return Pair(first: cell, second: checkCell);
    }

    return null;
  }

  void addNeighbour(HashSet<Pair> pairs, Pair? neighbour) {
    if (neighbour != null) {
      for (final pair in pairs) {
        if ((pair.first == neighbour.first && pair.second == neighbour.second) ||
          (pair.first == neighbour.second && pair.second == neighbour.first)
        ) {
          return;
        }
      }
      pairs.add(neighbour);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! Grid) return false;
    if (cells != other.cells) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + cells.hashCode;
    return result;
  }
}

class Pair {
  late final Cell first;
  late final Cell second;

  Pair({required this.first, required this.second});

  @override
  String toString() {
    return "($first, $second)";
  }

  @override
  bool operator ==(Object other) {
    if (other is! Pair) return false;
    if (first != other.first) return false;
    if (second != other.second) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + first.hashCode;
    result = 37 * result + second.hashCode;
    return result;
  }
}