import 'package:flutter/material.dart';

void dialog(BuildContext context, String title, String message) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, "OK"),
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}