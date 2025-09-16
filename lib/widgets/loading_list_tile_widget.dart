
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingListTileWidget extends StatelessWidget {
  const LoadingListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListTile(
        shape: Border(
          top: BorderSide(width: 1, color: Theme.of(context).primaryColor),
          bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.assignment_outlined, color: Colors.white),
        ),
        title: Text('TITLE IS HERE'),
        subtitle: Text('My Time darling dude'),
        trailing: Checkbox(
          activeColor: Colors.deepOrange,
          value: false,
          onChanged: (value) async {},
        ),
      ),
    );
  }
}
