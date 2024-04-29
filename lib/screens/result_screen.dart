import 'package:flutter/material.dart';
import 'package:webspark_test/screens/index.dart';

class ResultScreen extends Screen {
  const ResultScreen({super.key, required super.nextScreen});

  @override
  State<ResultScreen> createState() => _ResultScreenState();

  @override
  String title() => "Result list screen";
  
  @override
  Screen? previous() => HomeScreen(nextScreen: nextScreen);
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}