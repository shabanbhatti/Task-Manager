import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/splash%20page/splash_page.dart';
import 'package:task_manager_project/Pages/Intro%20Page/intro_page.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';

class DecidePage extends ConsumerStatefulWidget {
  const DecidePage({super.key});
  static const pageName = '/';

  @override
  ConsumerState<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends ConsumerState<DecidePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => whichPage());
  }

  void whichPage() async {
    var isOpened = await SharedPrefService.getBool(
      SharedPrefService.isAppOpenedKEY,
    );

    if (mounted) {
      if (isOpened == false) {
        Navigator.of(context).pushReplacementNamed(SplashPage.pageName);
      } else {
        Navigator.of(context).pushReplacementNamed(IntroPage.pageName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
