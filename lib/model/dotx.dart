class DotX {
  static final RegExp dotXScheme = RegExp(r'^[xX.]+$');

  late final String value;

  DotX(String s) {
    if (dotXScheme.hasMatch(s)) {
      value = s;
    } else {
      throw Exception("$s must consist only of X-s and .-s");
    }
  }
}