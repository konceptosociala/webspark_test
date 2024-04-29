import 'package:flutter/material.dart';
import 'screens/index.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Screen _currentScreen;

  @override
  void initState() {
    super.initState();
    _currentScreen = HomeScreen(nextScreen: nextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_currentScreen.title()),
          leading: _currentScreen.previous() != null
            ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => nextScreen(_currentScreen.previous()!),
            )
            : null,
        ),
        body: _currentScreen,
      ),
    );
  }

  void nextScreen(Screen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }
}
