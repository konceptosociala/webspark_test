import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const BottomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue[300], // Background color
            foregroundColor: Colors.black, // Text color
            side: const BorderSide(
              color: Colors.blue, // Border color
              width: 2.0, // Border width
            ),
            fixedSize: const Size(double.maxFinite, 60)
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      ]
    ));
  }
}