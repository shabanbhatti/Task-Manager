import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_circular_percent_indicator.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_data_widget.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_sliver_appbar_widget.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/widgets/loading_list_tile_widget.dart';

class BottomBarHome extends ConsumerStatefulWidget {
  const BottomBarHome({super.key});

  @override
  ConsumerState<BottomBarHome> createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends ConsumerState<BottomBarHome>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controllerForScale;

  late Animation<double> opacity;
  late Animation<double> scale;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(tasksProvider.notifier).fetchTasks();
    });
    controllerForScale =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controllerForScale.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controllerForScale.forward();
            }
          });
    scale = Tween<double>(begin: 0.9, end: 1.0).animate(controllerForScale);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    slide = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset.zero,
    ).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerForScale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Home With profile CALLED BUILD');
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          MyTopWidget(),
          HomeCircularPercentIndicator(opacity: opacity),

          // SliverToBoxAdapter(child: Divider()),
          SliverFadeTransition(
            opacity: opacity,
            sliver: SliverPadding(
              padding: EdgeInsets.only(top: 20, left: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Tasks',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          SliverFadeTransition(
            opacity: opacity,
            sliver: SliverToBoxAdapter(
              child: SlideTransition(
                position: slide,
                child: Consumer(
                  builder:
                      (context, taskRef, child) => switch (taskRef.watch(
                        tasksProvider,
                      )) {
                        InitialState() => const Row(
                          children: [
                            Icon(Icons.task),
                            Padding(
                              padding: EdgeInsets.all(7),
                              child: Text('No tasks yet'),
                            ),
                          ],
                        ),
                        LoadingState() => const LoadingListTileWidget(),
                        LoadedSuccessfuly(taskList: var taskList) =>
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: taskList.length,
                            itemBuilder: (context, index) {
                              bool isLast = index == taskList.length - 1;
                              return HomeDataWidget(
                                tasks: taskList[index],
                                isLast: isLast,
                              );
                            },
                          ),
                        ErrorState(error: var error) => Text(error),
                        EmptyState() => Padding(
                          padding: EdgeInsets.only(top: 100),
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
                      },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
