import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingListTileWidget extends StatelessWidget {
  const LoadingListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList.builder(
      itemExtent: 70,
      itemCount: 50,
      itemBuilder: (context, index) {
        return Skeletonizer(
          enabled: true,
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey.withAlpha(50),
              highlightColor: Colors.white.withAlpha(100),
              child: CircleAvatar(radius: 25, backgroundColor: Colors.grey),
            ),
            title: Text('TITLE IS HERE'),
            subtitle: Text('My Time darling dude'),
          ),
        );
      },
    );
  }
}
