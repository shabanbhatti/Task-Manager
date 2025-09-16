
import 'package:flutter/material.dart';


void deleteDialog(BuildContext context, void Function() onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete image?'),
        content: Text('Are you sure?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
