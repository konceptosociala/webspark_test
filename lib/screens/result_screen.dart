import 'package:flutter/material.dart';
import 'package:webspark_test/model/index.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/utils/index.dart';

class ResultScreen extends Screen {
  final List<Data> results;

  const ResultScreen({
    super.key, 
    required super.nextScreen, 
    required this.results,
  });

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
    return SingleChildScrollView(child: Column(children: widget.results
      .map((data) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
          foregroundColor: Colors.black, // Text color
          fixedSize: Size(MediaQuery.of(context).size.width, 40)
        ),
        onPressed: () => widget.nextScreen(PreviewScreen(
          nextScreen: widget.nextScreen, 
          resultScreen: widget,
          data: data,
        )),
        child: Text(pathToString(data.shortestPath!)),
      ))
      .toList()
    ));
  }
}