class Cell {
  final int x;
  final int y;
  final bool blocked;

  Cell({
    required this.x, 
    required this.y,
    required this.blocked,
  });

  factory Cell.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'x': int x,
        'y': int y,
      } => Cell(x: x, y: y, blocked: false),
      _ => throw const FormatException("Failed to load cell"),
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is! Cell) return false;
    if (x != other.x) return false;
    if (y != other.y) return false;
    if (blocked != other.blocked) return false;
    return true;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + x.hashCode;
    result = 37 * result + y.hashCode;
    result = 37 * result + blocked.hashCode;
    return result;
  }

  @override
  String toString() {
    return "{($x; $y), ${blocked ? "blocked" : "open"}}";
  }
}