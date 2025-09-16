import 'package:flutter/material.dart';

class GradientsBackgroundAppbarWidget extends StatelessWidget {
  const GradientsBackgroundAppbarWidget({super.key, this.child=const SizedBox()});
final Widget child;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
    
return Container(
    height:double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 6,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );

  },);
  }
}