import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/splash%20page/controllers/splash_animated_riverpod.dart';

class PageviewContainer extends StatelessWidget {
  const PageviewContainer({
    super.key,
    required this.topColor,
    required this.endColor,
    required this.imgPath,
    required this.pageTitle,
  });

  final Color topColor;
  final Color endColor;

  final String imgPath;
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topColor, endColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -40,
            left: 60,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withAlpha(70),
            ),
          ),
          Positioned(
            top: 100,
            left: 50,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(90),
            ),
          ),
          Positioned(
            top: 150,
            right: 300,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            top: 400,

            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            top: 360,
            right: 20,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            top: 300,
            left: 50,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            top: 170,
            right: 200,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Colors.white.withAlpha(150),
            ),
          ),

          // ----------------------------
          Positioned(
            bottom: 10,
            left: 60,
            child: CircleAvatar(backgroundColor: Colors.white.withAlpha(50)),
          ),
          Positioned(
            top: 170,
            left: -50,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withAlpha(50),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(30),
            ),
          ),
          Positioned(
            bottom: 180,
            right: 300,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            bottom: 360,
            right: 20,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            bottom: 300,
            left: 10,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withAlpha(50),
            ),
          ),
          Positioned(
            top: -10,
            right: -60,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),
          Positioned(
            bottom: 110,
            left: 300,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ),

          Align(
            alignment: const Alignment(0, -0.5),
            child: Consumer(
              builder:
                  (context, ref, child) => AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    scale: ref.watch(animatedScaleProvider),
                    child: Image.asset(
                      'assets/images/$imgPath',
                      height: 250,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.3),
            child: Text(
              pageTitle,
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
