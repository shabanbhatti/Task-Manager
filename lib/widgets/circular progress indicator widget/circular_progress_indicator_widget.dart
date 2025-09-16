import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularPercentIndicatorWidget extends StatefulWidget {
  const CircularPercentIndicatorWidget({
    super.key,
    required this.title,
    required this.color1,
    required this.color2,
    required this.text,
    required this.percent,
    required this.onTab,
  });

  /*
   height: mqSize.height * 0.35,
      width: mqSize.width * 0.45,
   */

  final title;
  final Color color1;
  final Color color2;
  final double percent;
  final String text;
  final void Function() onTab;
  @override
  State<CircularPercentIndicatorWidget> createState() =>
      _TotalCompletePendingState();
}

class _TotalCompletePendingState extends State<CircularPercentIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotate;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    rotate = Tween<double>(begin: 0.0, end: 2 * pi).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('TWO top ROTATE CIRCLES');

    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: rotate,
            child: InkWell(
              onTap: widget.onTab,
              child: Container(
                height: 200,
                // height/: 00,
                width: 300,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  // color: color,
                  gradient: LinearGradient(
                    colors: [widget.color1, widget.color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shadows:const [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 0,
                      color: const Color.fromARGB(255, 74, 73, 73),
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: widget.onTab,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularPercentIndicator(
                      percent: widget.percent,
                      animation: true,
                      animationDuration: 1500,

                      progressColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 122, 122, 122),
                      radius: 25,
                      lineWidth: 5,
                      center: Text(
                        '${widget.text}%',
                        style:const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
