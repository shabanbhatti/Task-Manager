import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/Intro%20Page/controllers/intro_controller.dart';
import 'package:task_manager_project/Pages/main%20root%20page/main_root_page.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});
  static const pageName = '/intro_page';

  @override
  ConsumerState<IntroPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<IntroPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(introPageProvider.notifier).animate();
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(MainRootPage.pageName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('First page Build Caled');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Consumer(
              builder:
                  (context, firstPageRef, child) => AnimatedSlide(
                    offset: Offset(0, firstPageRef.watch(introPageProvider)),
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 200,
                      width: 200,
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            spreadRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.orange],
                        ),
                      ),

                      alignment: Alignment.center,
                      child: Image.asset(
                        appLogo,
                        fit: BoxFit.fitHeight,
                        height: 150,
                      ),
                    ),
                  ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 250),
              child: const CupertinoActivityIndicator(
                radius: 15,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
