import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/controllers/date time controllers/date_riverpod.dart';
import 'package:task_manager_project/controllers/date time controllers/time_riverpod.dart';
import 'package:task_manager_project/controllers/selection btn controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection btn controller/selection_btn_controller.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/services/notification_service.dart';
import 'package:task_manager_project/utils/date_format.dart';
import 'package:task_manager_project/widgets/custom_btn.dart';

class AddTaskBtnWidget extends StatelessWidget {
  const AddTaskBtnWidget({
    super.key,
    required this.titleFormKey,
    required this.timeFormKey,
    required this.descrptionFormKey,
    required this.titleController,
    required this.descrptionController,
    required this.dateTime,
  });

  final GlobalKey<FormState> titleFormKey;
  final GlobalKey<FormState> timeFormKey;
  final GlobalKey<FormState> descrptionFormKey;

  final TextEditingController titleController;
  final TextEditingController descrptionController;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return CustomBtn(
          text: 'Create task',
          onTap: () async {
            final isTitleValid = titleFormKey.currentState!.validate();
            final isTimeValid = timeFormKey.currentState!.validate();
            final isDescriptionValid =
                descrptionFormKey.currentState!.validate();

            final selectedPriority = ref.read(selectionBtnProvider);

            if (!isTitleValid || !isTimeValid || !isDescriptionValid) return;

            if (selectedPriority.isEmpty) {
              ref
                  .read(nonSelectionErrorProvider.notifier)
                  .onSelect(selectedPriority);
              return;
            }

            final dateProviderRef = ref.read(dateProvider);
            final timeProviderRef = ref.read(timeProvider);

            final task = Tasks(
              title: titleController.text,
              description: descrptionController.text,
              importance: selectedPriority,
              date:
                  dateProviderRef.controller.text.isEmpty
                      ? dateFormat(dateTime)
                      : dateProviderRef.controller.text,
              time: timeProviderRef.controller.text,
            );

            final taskId = await ref
                .read(tasksProvider.notifier)
                .insertTask(task);

            log(dateProviderRef.dateTime.day.toString());
            log(dateProviderRef.dateTime.month.toString());
            log(dateProviderRef.dateTime.year.toString());

            await NotificationService().scheduleNotification(
              id: taskId,
              title: titleController.text,
              body: "Time is up. Don't forget to complete the task.",
              hour: timeProviderRef.timeOfDay.hour,
              min: timeProviderRef.timeOfDay.minute,
              priority: selectedPriority,
              day:
                  dateProviderRef.controller.text.isEmpty
                      ? null
                      : dateProviderRef.dateTime.day,
              month:
                  dateProviderRef.controller.text.isEmpty
                      ? null
                      : dateProviderRef.dateTime.month,
              year:
                  dateProviderRef.controller.text.isEmpty
                      ? null
                      : dateProviderRef.dateTime.year,
            );

            Navigator.pop(context);
          },
        );
      },
    );
  }
}
