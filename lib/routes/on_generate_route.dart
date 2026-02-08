import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Pages/Decide%20page/decide_page.dart';
import 'package:task_manager_project/Pages/View%20task%20page/view_task_page.dart';
import 'package:task_manager_project/Pages/add%20task%20page/add_task_page.dart';
import 'package:task_manager_project/Pages/pending%20tasks%20page/pending_tasks_page.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/search_tasks_page.dart';
import 'package:task_manager_project/Pages/splash%20page/splash_page.dart';
import 'package:task_manager_project/Pages/update%20task%20page/update_task_page.dart';
import 'package:task_manager_project/Pages/completed%20tasks%20page/completed_tasks_page.dart';
import 'package:task_manager_project/Pages/theme%20page/theme_page.dart';
import 'package:task_manager_project/Pages/update%20user%20identity%20page/update_user_identity_page.dart';
import 'package:task_manager_project/Pages/user%20information%20page/user_info_page.dart';
import 'package:task_manager_project/Pages/profile%20page/profile_page.dart';
import 'package:task_manager_project/Pages/main%20root%20page/main_root_page.dart';
import 'package:task_manager_project/Pages/Intro%20Page/intro_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings rs) {
  switch (rs.name) {
    case DecidePage.pageName:
      return MaterialPageRoute(builder: (context) => const DecidePage());
    case SplashPage.pageName:
      return MaterialPageRoute(
        builder: (context) => const SplashPage(),
        settings: rs,
      );
    case IntroPage.pageName:
      return MaterialPageRoute(
        builder: (context) => const IntroPage(),
        settings: rs,
      );
    case MainRootPage.pageName:
      return MaterialPageRoute(
        builder: (context) => const MainRootPage(),
        settings: rs,
      );
    case ProfilePage.pageName:
      return PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const ProfilePage(),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) => SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(-1, 0), end: Offset.zero),
              ),
              child: child,
            ),
        settings: rs,
      );
    case ThemeButton.pageName:
      return CupertinoPageRoute(
        builder: (context) => const ThemeButton(),
        settings: rs,
      );
    case UpdateButton.pageName:
      return CupertinoPageRoute(
        builder: (context) => const UpdateButton(),
        settings: rs,
      );
    case UserInfoPage.pageName:
      return CupertinoPageRoute(
        builder: (context) => const UserInfoPage(),
        settings: rs,
      );
    case AddTask.pageName:
      return MaterialPageRoute(builder: (context) => const AddTask());

    case ViewTaskPage.pageName:
      return MaterialPageRoute(
        builder: (context) {
          Map<String, dynamic> map = rs.arguments as Map<String, dynamic>;
          Tasks tasks = map['tasks'] as Tasks;
          bool isFromComplete = map['isFromComplete'] as bool;
          return ViewTaskPage(tasks: tasks, isViewCompletePage: isFromComplete);
        },
        settings: rs,
      );
    case UpdateTask.pageName:
      return MaterialPageRoute(
        builder: (context) => UpdateTask(tasks: rs.arguments as Tasks),
        settings: rs,
      );

    case SearchPage.pageName:
      return CupertinoPageRoute(builder: (context) => const SearchPage());

    case PendingTasksPage.pageName:
      return CupertinoPageRoute(
        builder:
            (context) =>
                PendingTasksPage(isAHomePendingPage: rs.arguments as bool),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const IntroPage(),
        settings: rs,
      );
  }
}
