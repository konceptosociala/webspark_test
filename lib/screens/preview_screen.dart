import 'package:flutter/material.dart';
import 'package:webspark_test/screens/index.dart';

class PreviewScreen extends Screen {
  final ResultScreen results;

  const PreviewScreen({
    super.key, 
    required super.nextScreen,
    required this.results,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();

  @override
  String title() => "Preview screen";

  @override
  Screen? previous() => results;
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: []);
  }
}