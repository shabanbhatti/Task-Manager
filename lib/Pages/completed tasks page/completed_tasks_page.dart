import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/View task page/view_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';

class CompletedTasksPage extends ConsumerStatefulWidget {
  const CompletedTasksPage({super.key});

  static const pageName = '/view_complete_tasks';

  @override
  ConsumerState<CompletedTasksPage> createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends ConsumerState<CompletedTasksPage>
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
      body: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            _CompletedHeader(),

            switch (taskState) {
              LoadingTaskState() => const LoadingListTileWidget(),

              LoadedTaskSuccessfuly(completedTasks: var completedTasks) =>
                SliverList.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ViewTaskPage.pageName,
                          arguments: {'tasks': task, 'isFromComplete': true},
                        );
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: Icon(
                          Icons.assignment_turned_in,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        task.title.toString(),
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Due: ${task.date} at ${task.time}'),
                      trailing: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.green),
                      ),
                    );
                  },
                ),

              _ => const SliverFillRemaining(child: _EmptyCompletedView()),
            },
          ],
        ),
      ),
    );
  }
}

class _CompletedHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(tasksProvider);

    int percentText = 0;

    if (taskState is LoadedTaskSuccessfuly) {
      final remaining = taskState.taskList.length;
      final completed = taskState.completedTasks.length;
      final total = remaining + completed;

      percentText = total == 0 ? 0 : ((completed / total) * 100).toInt();
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Completed Tasks',
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

class _EmptyCompletedView extends StatelessWidget {
  const _EmptyCompletedView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, color: Colors.deepOrange),
          SizedBox(width: 5),
          Text(
            'No completed found',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
