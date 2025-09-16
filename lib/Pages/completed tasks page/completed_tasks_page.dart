import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/View%20task%20page/view_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';


class CompletedTasksPage extends ConsumerStatefulWidget {
  const CompletedTasksPage({super.key});
  static const pageName = '/view_complete_tasks';

  @override
  ConsumerState<CompletedTasksPage> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends ConsumerState<CompletedTasksPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();
Future.microtask(() {
  ref.read(tasksProvider.notifier).fetchCompletedTasks();
},)  ;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    slide = Tween<Offset>(
      begin: const Offset(0, 2),
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
    print('Completed TASKS PAGE');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(tasksProvider.notifier).fetchTasks();
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back, color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background:const GradientsBackgroundAppbarWidget(),
          centerTitle: true,
          title: const Text(
            'Completed tasks',
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
                  LoadedSuccessfuly(completedTasks: var compList) =>
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: compList.length,
                      itemBuilder:
                          (context, index) => ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ViewTaskPage.pageName,
                                arguments:  {
                                              'tasks':compList[index],
                                              'isFromComplete':true
                                            },
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: Icon(
                                Icons.assignment_turned_in,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              compList[index].title.toString(),
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Due: ${compList[index].date} at ${compList[index].time}',
                            ),
                            trailing: Text(
                              'Completed',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                    ),
                  ErrorState(error: var error) => Text(error),
                  EmptyState() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, color: Colors.deepOrange),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'No completed found',
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
