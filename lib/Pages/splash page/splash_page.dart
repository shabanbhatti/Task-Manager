import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:task_manager_project/Pages/Intro%20Page/intro_page.dart';
import 'package:task_manager_project/Pages/splash%20page/controllers/splash_animated_riverpod.dart';
import 'package:task_manager_project/Pages/splash%20page/controllers/splash_page_view_cntroller.dart';
import 'package:task_manager_project/Pages/splash%20page/widgets/splash_designing_circle_dots_widget.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
  static const pageName = '/splash_page';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    ref.read(animatedScaleProvider.notifier).animate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // late var mqSize;

  @override
  Widget build(BuildContext context) {
    print('Intro Build called');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  PageviewContainer(
                    topColor: Colors.yellow,
                    endColor: Colors.teal,
                    imgPath: 'logo_3.png',
                    pageTitle: 'Create your tasks.',
                  ),
                  PageviewContainer(
                    topColor: Colors.red,
                    endColor: Colors.purple,
                    imgPath: 'logo_2.png',
                    pageTitle: 'Complete your tasks',
                  ),

                  PageviewContainer(
                    topColor: Colors.blue,
                    endColor: Colors.blueGrey,
                    imgPath: 'logo_1.png',
                    pageTitle: 'Pending tasks',
                  ),
                ],
              ),

              Positioned(
                bottom: 70,
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,

                  effect: ExpandingDotsEffect(
                    radius: 20,
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: Colors.white.withAlpha(150),
                    activeDotColor: Colors.white,
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(0, 0.65),
                child: SizedBox(
                  height: 50,
                  width: 130,
                  child: Consumer(
                    builder:
                        (context, conRef, child) => OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 0.5, color: Colors.grey),
                            backgroundColor: Colors.white.withAlpha(100),
                          ),
                          onPressed: () async {
                            final currentIndex = conRef.watch(
                              pageviewNavigateProvider,
                            );
                            final notifier = ref.read(
                              pageviewNavigateProvider.notifier,
                            );

                            if (currentIndex < 2) {
                              notifier.pageviewNavigate();
                              controller.animateToPage(
                                currentIndex + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInExpo,
                              );
                            } else {
                              SharedPrefService.setBool(
                                SharedPrefService.isAppOpenedKEY,
                                true,
                              );
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(IntroPage.pageName);
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
