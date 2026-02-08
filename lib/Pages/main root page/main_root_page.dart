import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/add%20task%20page/add_task_page.dart';
import 'package:task_manager_project/Pages/home%20page/home_page.dart';
import 'package:task_manager_project/Pages/pending%20tasks%20page/pending_tasks_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/user_registration_model_bottom_sheet.dart';

class MainRootPage extends ConsumerStatefulWidget {
  const MainRootPage({super.key});
  static const pageName = '/home';

  @override
  ConsumerState<MainRootPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MainRootPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tasksProvider.notifier).fetchCompletedTasks();
      ref.read(tasksProvider.notifier).fetchTasks();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showBottomSheetInInit();
    });
  }

  void showBottomSheetInInit() async {
    var isSaveIdentity = await SharedPrefService.getBool(
      SharedPrefService.isUserIdentifiedKEY,
    );

    if (isSaveIdentity == false) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          useregistrationModelBottomSheet(context);
        }
      });
    }
  }

  List<Widget> myWidgets = const [
    const BottomBarHome(),
    const PendingTasksPage(isAHomePendingPage: false),
  ];

  @override
  Widget build(BuildContext context) {
    print('Home BOTTOM BAR CALLED Build called');

    return Scaffold(
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          elevation: 5,

          onPressed: () {
            var userState = ref.read(userDatabaseProvider);
            if (userState is LoadedUserSuccessfuly) {
              print('successfuly');
              Navigator.pushNamed(context, AddTask.pageName);
            } else {
              print('error');
              useregistrationModelBottomSheet(context);
            }
          },
          backgroundColor: Colors.deepOrangeAccent,
          shape: const CircleBorder(),

          child: const Icon(
            Icons.assignment_add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),

      bottomNavigationBar: Consumer(
        builder:
            (context, bottombarProvider, child) => ConvexAppBar(
              gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
              initialActiveIndex: bottombarProvider.watch(bottomBarProvider),
              activeColor: Colors.white,

              onTap: (index) {
                bottombarProvider.read(bottomBarProvider.notifier).onTap(index);
              },
              height: 50,
              curve: Curves.bounceInOut,
              curveSize: 0,

              items: const [
                TabItem(
                  icon: Icon(Icons.home, color: Colors.white, size: 30),

                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.deepOrange,
                    size: 35,
                  ),
                ),

                TabItem(
                  icon: Icon(Icons.schedule, color: Colors.white, size: 30),
                  activeIcon: Icon(
                    Icons.schedule,
                    color: Colors.deepOrange,
                    size: 30,
                  ),
                ),
              ],
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Consumer(
        builder:
            (context, bottombarProvider, child) =>
                myWidgets[bottombarProvider.watch(bottomBarProvider)],
      ),
    );
  }
}

final bottomBarProvider = StateNotifierProvider<BottomBarStateNotifier, int>((
  ref,
) {
  return BottomBarStateNotifier();
});

class BottomBarStateNotifier extends StateNotifier<int> {
  BottomBarStateNotifier() : super(0);

  Future<void> onTap(int index) async {
    state = index;
  }

  void clickToPendingCircle() {
    state = 2;
  }
}
