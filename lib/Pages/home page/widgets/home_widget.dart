import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_data_widget.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Tasks',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Consumer(
            builder: (context, taskRef, child) {
              var taskState = taskRef.watch(tasksProvider);
              if (taskState is LoadingTaskState) {
                return const LoadingListTileWidget();
              } else if (taskState is LoadedTaskSuccessfuly) {
                var taskList = taskState.taskList;
                if (taskList.isNotEmpty) {
                  return SliverList.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      bool isLast = index == taskList.length - 1;
                      return HomeDataWidget(
                        tasks: taskList[index],
                        isLast: isLast,
                      );
                    },
                  );
                } else {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment, color: Colors.deepOrange),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'No tasks added yet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return const SliverFillRemaining(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment, color: Colors.deepOrange),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'No tasks added yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
