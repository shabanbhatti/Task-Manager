import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({super.key, required this.onTap, required this.text});

final void Function() onTap;
final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onTap,
    child: LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Container(
          height: 50,
          width: mqSize.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    ),
  );
  }
}