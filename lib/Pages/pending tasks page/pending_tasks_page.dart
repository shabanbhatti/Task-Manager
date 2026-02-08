import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/View task page/view_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';

class PendingTasksPage extends ConsumerStatefulWidget {
  const PendingTasksPage({super.key, required this.isAHomePendingPage});

  final bool isAHomePendingPage;
  static const pageName = 'pending_tasks';

  @override
  ConsumerState<PendingTasksPage> createState() => _PendingTasksPageState();
}

class _PendingTasksPageState extends ConsumerState<PendingTasksPage>
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
    final taskState = ref.watch(tasksProvider);

    return Scaffold(
      appBar:
          widget.isAHomePendingPage
              ? null
              : AppBar(
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  background: GradientsBackgroundAppbarWidget(),
                  title: Text(
                    'Pending tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      body: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            _PendingHeader(),

            switch (taskState) {
              InitialTaskState() => const SliverFillRemaining(
                child: Center(child: Text('No Data found')),
              ),

              LoadingTaskState() => const LoadingListTileWidget(),

              LoadedTaskSuccessfuly(taskList: var taskList) =>
                (taskList.isNotEmpty)
                    ? SliverList.builder(
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        final task = taskList[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ViewTaskPage.pageName,
                              arguments: {
                                'tasks': task,
                                'isFromComplete': false,
                              },
                            );
                          },
                          leading: const CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            child: Icon(Icons.assignment, color: Colors.white),
                          ),
                          title: Text(
                            task.title.toString(),
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Due: ${task.date} at ${task.time}'),
                          trailing: const Icon(
                            Icons.schedule_outlined,
                            size: 30,
                          ),
                        );
                      },
                    )
                    : SliverFillRemaining(child: _EmptyPendingView()),

              ErrorTaskState(error: var error) => SliverFillRemaining(
                child: Center(child: Text(error)),
              ),

              EmptyTaskState() => const SliverFillRemaining(
                child: _EmptyPendingView(),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _PendingHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(tasksProvider);

    int percentText = 0;

    if (taskState is LoadedTaskSuccessfuly) {
      final remaining = taskState.taskList.length;
      final completed = taskState.completedTasks.length;
      final total = remaining + completed;

      percentText = total == 0 ? 0 : ((remaining / total) * 100).toInt();
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pendings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              '$percentText%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                decoration: TextDecoration.underline,
                decorationColor: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPendingView extends StatelessWidget {
  const _EmptyPendingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assignment, color: Colors.deepOrange),
          SizedBox(width: 5),
          Text(
            'No pending tasks',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
