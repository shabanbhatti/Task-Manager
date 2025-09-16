
import 'package:flutter/material.dart';


void showOptionsBottomSheet(
  BuildContext context,
  void Function() onOpen,
  void Function() onDelete,
  void Function() onUpdate,
) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text('Open'),
              onTap: onOpen,
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Update'),
              onTap: onUpdate,
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: onDelete,
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
