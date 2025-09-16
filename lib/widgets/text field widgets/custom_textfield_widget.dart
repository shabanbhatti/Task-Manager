

import 'package:flutter/material.dart';
class CustomTextfieldWidget extends StatelessWidget {
   CustomTextfieldWidget({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.onFieldSubmitted,
    required this.title,
    required this.globalKey,
    this.color=Colors.transparent
  });
  final FocusNode focusNode;
  final void Function(String) onFieldSubmitted;
  final String title;
  final TextEditingController controller;
  final GlobalKey<FormState> globalKey;
 final Color color;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalKey,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Field shouldn't be empty.";
          } else {
            return null;
          }
        },
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: title,

          hintStyle: const TextStyle(color: Color.fromARGB(255, 128, 128, 128)),
          fillColor: color==Colors.transparent?Colors.grey.withAlpha(120):color,
          filled: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
