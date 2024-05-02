import 'package:flutter/material.dart';
import 'package:webspark_test/model/index.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/utils/index.dart';

class PreviewScreen extends Screen {
  final ResultScreen resultScreen;
  final Data data;

  const PreviewScreen({
    super.key, 
    required super.nextScreen,
    required this.resultScreen, 
    required this.data,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();

  @override
  String title() => "Preview screen";

  @override
  Screen? previous() => resultScreen;
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.data.grid.width
          ), 
          itemCount: widget.data.grid.width * widget.data.grid.height,
          itemBuilder: (context, index) {
            int rowIndex = index ~/ widget.data.grid.width;
            int colIndex = index % widget.data.grid.width;
            
            Cell cell = widget.data.grid.getCell(colIndex, rowIndex)!;

            Color cellColor = Colors.white;
            Color textColor = Colors.black;

            if (widget.data.shortestPath!.contains(cell)) {
              cellColor = const Color.fromARGB(255, 76, 175, 79);
              textColor = Colors.white;
            }

            if (cell.blocked) {
              cellColor = Colors.black;
              textColor = Colors.white;
            }

            if (cell == widget.data.start) {
              cellColor = const Color.fromARGB(255, 100, 255, 218);
              textColor = Colors.black;
            }

            if (cell == widget.data.end) {
              cellColor = const Color.fromARGB(255, 0, 150, 136);
              textColor = Colors.white;
            }

            return GridTile(
              child: Container(
                color: cellColor,
                child: Center(
                  child: Text(
                    '(${cell.x}; ${cell.y})',
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
        ),
        const SizedBox(height: 16),
        Text(
          pathToString(widget.data.shortestPath!), 
          textAlign: TextAlign.center
        ),
      ]
    );
  }
}