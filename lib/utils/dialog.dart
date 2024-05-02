// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

Future<void> dialog(BuildContext context, String title, String message) async {
  await Future.delayed(const Duration(milliseconds: 250));
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