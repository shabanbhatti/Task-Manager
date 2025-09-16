import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Pages/View%20task%20page/view_task_page.dart';

import 'package:task_manager_project/Pages/update%20task%20page/update_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/utils/dialog%20boxes/delete_dialog.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/options_model_bottom_sheet.dart';
import 'package:task_manager_project/widgets/list%20tile%20widget/(home%20&%20search)list_tile_widget.dart';

class HomeDataWidget extends StatelessWidget {
  const HomeDataWidget({super.key, required this.tasks, required this.isLast});
final Tasks tasks;
final bool isLast;
  @override
  Widget build(BuildContext context) {
    return   Consumer(
      builder: (context, ref, _) {
        return InkWell(
                                onLongPress: () {
                                  showOptionsBottomSheet(
                                    context,
                                    () {
                                      Navigator.of(context)
                                          .pushNamed(
                                            ViewTaskPage.pageName,
                                            arguments: {
                                              'tasks':tasks,
                                              'isFromComplete':false
                                            } as Map<String, dynamic>,

                                          )
                                          .then((value) {
                                            Navigator.pop(context);
                                          });
                                    },
                                    () {
                                      showDeleteDialog(context, () {
                                        ref
                                            .read(tasksProvider.notifier)
                                            .deleteTask(tasks)
                                            .then((value) {});
                                      }).then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    () {
                                      Navigator.pushNamed(
                                        context,
                                        UpdateTask.pageName,
                                        arguments: tasks,
                                      ).then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                },
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ViewTaskPage.pageName,
                                    arguments:  {
                                              'tasks':tasks,
                                              'isFromComplete':false
                                            } as Map<String, dynamic>,
                                  );
                                },
                                child: HomeAndSearchListTile(
                                  tasks: tasks,
                                  isLast: isLast,
                                 
                                ),
                              );
      }
    );
  }
}