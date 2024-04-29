import 'package:flutter/material.dart';
import 'package:webspark_test/screens/index.dart';

class ProcessScreen extends Screen {
  final Uri uri;

  const ProcessScreen({
    super.key, 
    required this.uri,
    required super.nextScreen,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();

  @override
  String title() => "Process screen";

  @override
  Screen? previous() => HomeScreen(nextScreen: nextScreen);
}

class _ProcessScreenState extends State<ProcessScreen> {
  // Uri uri = 

  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}