import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/controllers/search_controller.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/services/notification_service.dart';
import 'package:task_manager_project/utils/dialog%20boxes/completion_dialog.dart';

class HomeAndSearchListTile extends ConsumerWidget {
  const HomeAndSearchListTile({
    super.key,
    required this.tasks,
    required this.isLast,
  });
  final Tasks tasks;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(tasks.taskPrimaryKey);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.assignment_outlined, color: Colors.white),
      ),
      title: Text(
        tasks.title.toString(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(children: [Text('Due: ${tasks.date} at ${tasks.time}')]),
      trailing: Checkbox(
        activeColor: Colors.deepOrange,
        value: tasks.isCompleted,
        onChanged: (value) async {
          showTaskCompletionDialog(context, () {
            ref
                .read(tasksProvider.notifier)
                .onChangedCheckBoxButton(value!, tasks);

            ref.read(searchListProvider.notifier).onCheck(value, tasks);

            if (value) {
              log('CALLED CANCEL NOTI BY ID');
              NotificationService().cancelNotificationById(
                tasks.taskPrimaryKey!,
              );
            }
          });
        },
      ),
    );
  }
}
