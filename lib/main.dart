import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/routes/on_generate_route.dart';
import 'package:task_manager_project/Pages/Decide%20page/decide_page.dart';

import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/notification_service.dart';
import 'package:task_manager_project/controllers/theme_controller.dart';

import 'package:task_manager_project/Theme/theme.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  var container = ProviderContainer();
  await container.read(themeByRadioProvider.notifier).getTheme();
  await container.read(userDatabaseProvider.notifier).fetchUser();
  // await container.read(tasksProvider.notifier).fetchTasks();
  await NotificationService().initializeNotification();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final groupValue = ref.watch(
          themeByRadioProvider.select((value) => value.groupValue),
        );
        final themeData = ref.watch(
          themeByRadioProvider.select((value) => value.themeData),
        );

        return MaterialApp(
          theme: (groupValue == 'System') ? lightMode : themeData,
          darkTheme: (groupValue == 'System') ? darkMode : null,
          debugShowCheckedModeBanner: false,
          initialRoute: DecidePage.pageName,

          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
