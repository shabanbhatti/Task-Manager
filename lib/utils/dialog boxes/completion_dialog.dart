
import 'dart:ui';

import 'package:flutter/material.dart';

void showTaskCompletionDialog(BuildContext context, VoidCallback onYes) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Task Completion'),
        content: Text('Are you sure you have completed this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
