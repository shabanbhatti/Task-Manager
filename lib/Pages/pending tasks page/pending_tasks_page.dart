import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/View%20task%20page/view_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';


class PendingTasksPage extends StatefulWidget {
  const PendingTasksPage({super.key, required this.isAHomePendingPage});
final bool isAHomePendingPage;
static const pageName= 'pending_tasks';
  @override
  State<PendingTasksPage> createState() =>
      _PendingTasksBottomBarPageState();
}

class _PendingTasksBottomBarPageState extends State<PendingTasksPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    slide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('INIT CALLED PENDINGS PAGE');
    return Scaffold(
      appBar: AppBar(
        leading:widget.isAHomePendingPage?IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:const Icon(CupertinoIcons.back),
        ): const SizedBox(),
        flexibleSpace: FlexibleSpaceBar(
          background:const GradientsBackgroundAppbarWidget(),
          centerTitle: true,
          title: const Text(
            'Pending tasks',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: SlideTransition(
          position: slide,
          child: Consumer(
            builder:
                (context, ref, child) => switch (ref.watch(tasksProvider)) {
                  InitialState() => Text('No Data found'),
                  LoadingState() => const LoadingListTileWidget(),
                  LoadedSuccessfuly(taskList: var taskList) => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: taskList.length,
                    itemBuilder:
                        (context, index) => ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ViewTaskPage.pageName,
                              arguments: {
                                              'tasks':taskList[index],
                                              'isFromComplete':false
                                            },
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            child:const Icon(
                              Icons.assignment_turned_in,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            taskList[index].title.toString(),
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Due: ${taskList[index].date} at ${taskList[index].time}',
                          ),
                          trailing:const Icon(Icons.schedule_outlined, size: 30),
                        ),
                  ),
                  ErrorState(error: var error) => Text(error),
                  EmptyState() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Icon(Icons.assignment, color: Colors.deepOrange),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child:const Text(
                          'No pending tasks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                },
          ),
        ),
      ),
    );
  }
}
