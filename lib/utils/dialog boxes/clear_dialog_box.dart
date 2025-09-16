
import 'package:flutter/material.dart';

void showClearCacheDialog(BuildContext context, void Function() onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Clear All Data?'),
        content: Text(
          'This will delete all local database and saved settings. Are you sure?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          TextButton(
            onPressed: onDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
