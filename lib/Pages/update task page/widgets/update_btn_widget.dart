import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';

import 'package:task_manager_project/controllers/date%20time%20controllers/date_riverpod.dart';
import 'package:task_manager_project/controllers/date%20time%20controllers/time_riverpod.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/services/notification_service.dart';
import 'package:task_manager_project/utils/date_format.dart';
import 'package:task_manager_project/widgets/custom_btn.dart';

class UpdateBtnWidget extends StatelessWidget {
  const UpdateBtnWidget({super.key, required this.titleFormKey, required this.timeFormKey, required this.descrptionFormKey, required this.tasks, required this.titleController, required this.descrptionController, required this.dateTime});
final GlobalKey<FormState> titleFormKey;
final GlobalKey<FormState> timeFormKey;
final GlobalKey<FormState> descrptionFormKey;
final Tasks tasks;
final TextEditingController titleController;
final TextEditingController descrptionController;
final DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomBtn(onTap: () async {
                                    var isTitleValidate =
                                        titleFormKey.currentState!.validate();
                                    var isTimeValidate =
                                        timeFormKey.currentState!.validate();
                                    var isDesciptionValidate =
                                        descrptionFormKey.currentState!.validate();
        
                                    if (isTitleValidate &&
                                        isTimeValidate &&
                                        isDesciptionValidate &&
                                        ref.watch(selectionBtnProvider) !=
                                            '') {
                                    var data= await  ref
                                          .read(tasksProvider.notifier)
                                          .updateTask(
                                            Tasks(
                                              taskPrimaryKey: tasks.taskPrimaryKey,
                                              description:
                                                  descrptionController.text,
                                              title: titleController.text,
                                              importance: ref.read(
                                                selectionBtnProvider,
                                              ),
                                              date:
                                                  (ref
                                                          .read(dateProvider)
                                                          .controller
                                                          .text
                                                          .isEmpty)
                                                      ? dateFormat(dateTime)
                                                      : ref
                                                          .read(dateProvider)
                                                          .controller
                                                          .text,
                                              time:
                                                  ref
                                                      .read(timeProvider)
                                                      .controller
                                                      .text,
                                            ),
                                          );
        
                                          if (data) {
                                            print('UPDATED SUCCESSFULY');
                                           
                                          NotificationService()
                                          .scheduleNotification(
                                             id: tasks.taskPrimaryKey!,
                                            title: titleController.text,
                                            body:
                                                "Time is up. Don't forget to complete the task.",
                                            hour:
                                                ref
                                                    .read(timeProvider)
                                                    .timeOfDay
                                                    .hour,
                                            min:
                                                ref
                                                    .read(timeProvider)
                                                    .timeOfDay
                                                    .minute,
                                            priority: ref.read(
                                              selectionBtnProvider,
                                            ),
                                            day:
                                                (ref
                                                        .read(dateProvider)
                                                        .controller
                                                        .text
                                                        .isEmpty)
                                                    ? null
                                                    : ref
                                                        .read(dateProvider)
                                                        .dateTime
                                                        .day,
        
                                            month:
                                                (ref
                                                        .read(dateProvider)
                                                        .controller
                                                        .text
                                                        .isEmpty)
                                                    ? null
                                                    : ref
                                                        .read(dateProvider)
                                                        .dateTime
                                                        .month,
        
                                            year:
                                                (ref
                                                        .read(dateProvider)
                                                        .controller
                                                        .text
                                                        .isEmpty)
                                                    ? null
                                                    : ref
                                                        .read(dateProvider)
                                                        .dateTime
                                                        .year,
                                          )
                                          .then((value) {
                                            ref
                                                .read(tasksProvider.notifier)
                                                .fetchTasks();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                          
                                          }else{
                                            print('NOT UPDATED');
                                          }
        
                                      
                                    } else {
                                      if (ref.watch(selectionBtnProvider) ==
                                          '') {
                                            var value= ref.watch(selectionBtnProvider);
                                        ref
                                            .read(
                                              nonSelectionErrorProvider
                                                  .notifier,
                                            ).onSelect(value);
                                      }
                                    }
                                  },text: 'Update task');
      }
    );
  }
}