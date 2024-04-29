import 'package:flutter/material.dart';

export 'home_screen.dart';
export 'preview_screen.dart';
export 'process_screen.dart';
export 'result_screen.dart';

abstract class Screen extends StatefulWidget {
  final Function(Screen screen) nextScreen;

  const Screen({
    super.key, 
    required this.nextScreen,
  });

  String title();

  Screen? previous();  
}