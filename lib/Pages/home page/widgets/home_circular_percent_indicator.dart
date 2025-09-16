import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager_project/Pages/completed%20tasks%20page/completed_tasks_page.dart';
import 'package:task_manager_project/Pages/pending%20tasks%20page/pending_tasks_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/circular%20progress%20indicator%20widget/circular_progress_indicator_widget.dart';

class HomeCircularPercentIndicator extends StatelessWidget {
  const HomeCircularPercentIndicator({super.key, required this.opacity});
  final Animation<double> opacity;
  @override
  Widget build(BuildContext context) {
    return SliverFadeTransition(
      opacity: opacity,
      sliver: SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          delegate: SliverChildListDelegate([
            Consumer(
              builder: (context, taskProvider, child) {
                var taskRef = taskProvider.watch(tasksProvider);
                if (taskRef is InitialState) {
                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(PendingTasksPage.pageName, arguments: true);
                    },
                    percent: 0.0,
                    text: '0',
                    title: 'Pendings',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                } else if (taskRef is LoadingState) {
                  return Skeletonizer(
                    child: CircularPercentIndicatorWidget(
                      onTab: () {
                        Navigator.of(
                          context,
                        ).pushNamed(PendingTasksPage.pageName, arguments: true);
                      },
                      percent: 0.0,
                      text: '0',
                      title: 'Pendings',
                      color1: const Color.fromARGB(255, 239, 51, 37),
                      color2: const Color.fromARGB(255, 255, 167, 34),
                    ),
                  );
                } else if (taskRef is LoadedSuccessfuly) {
                  final remaining = taskRef.taskList.length;
                  final completed = taskRef.completedTasks.length;
                  final total = remaining + completed;

                  final percent = total == 0 ? 0.0 : remaining / total;
                  final percentText = (percent * 100).toInt();

                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(PendingTasksPage.pageName, arguments: true);
                    },
                    percent: percent,
                    text: percentText.toString(),
                    title: 'Pendings',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                } else {
                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(PendingTasksPage.pageName, arguments: true);
                    },
                    percent: 0.0,
                    text: '0',
                    title: 'Pendings',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                }
              },
            ),

            Consumer(
              builder: (context, taskProvider, child) {
                var taskRef = taskProvider.watch(tasksProvider);
                if (taskRef is InitialState) {
                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(CompletedTasksPage.pageName);
                    },
                    percent: 0.0,
                    text: '0',
                    title: 'Completed',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                } else if (taskRef is LoadingState) {
                  return Skeletonizer(
                    child: CircularPercentIndicatorWidget(
                      onTab: () {
                        Navigator.of(
                          context,
                        ).pushNamed(CompletedTasksPage.pageName);
                      },
                      percent: 0.0,
                      text: '0',
                      title: 'Completed',
                      color1: const Color.fromARGB(255, 239, 51, 37),
                      color2: const Color.fromARGB(255, 255, 167, 34),
                    ),
                  );
                } else if (taskRef is LoadedSuccessfuly) {
                  final remaining = taskRef.taskList.length;
                  final completed = taskRef.completedTasks.length;
                  final total = remaining + completed;

                  final percent = total == 0 ? 0.0 : completed / total;
                  final percentText = (percent * 100).toInt();

                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(CompletedTasksPage.pageName);
                    },
                    percent: percent,
                    text: percentText.toString(),
                    title: 'Completed',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                } else {
                  return CircularPercentIndicatorWidget(
                    onTab: () {
                      Navigator.of(
                        context,
                      ).pushNamed(CompletedTasksPage.pageName);
                    },
                    percent: 0.0,
                    text: '0',
                    title: 'Completed',
                    color1: const Color.fromARGB(255, 239, 51, 37),
                    color2: const Color.fromARGB(255, 255, 167, 34),
                  );
                }
              },
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
          ),
        ),
      ),
    );
  }
}
