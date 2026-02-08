import 'package:flutter/material.dart';
import 'package:task_manager_project/Pages/home%20page/utils/home_bottomsheet_widget.dart';

void useregistrationModelBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return ShowBottomSheetWidgets(scrollController: scrollController);
        },
      );
    },
  );
}
