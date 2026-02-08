import 'package:flutter/material.dart';
import 'package:task_manager_project/Pages/completed%20tasks%20page/completed_tasks_page.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_sliver_appbar_widget.dart';
import 'package:task_manager_project/Pages/home%20page/widgets/home_widget.dart';
import 'package:task_manager_project/Pages/pending%20tasks%20page/pending_tasks_page.dart';

class BottomBarHome extends StatefulWidget {
  const BottomBarHome({super.key});

  @override
  State<BottomBarHome> createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<BottomBarHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Home page CALLED BUILD');
    return const DefaultTabController(
      length: 3,

      initialIndex: 0,
      child: const Column(
        children: [
          const MyTopWidget(),
          Expanded(
            child: TabBarView(
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomeWidget(),

                const PendingTasksPage(isAHomePendingPage: true),
                const CompletedTasksPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
