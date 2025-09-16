

import 'package:flutter/material.dart';

class DateTimeTextFormField extends StatelessWidget {
  const DateTimeTextFormField({
    super.key,
    required this.controller,
    required this.myKey,

    required this.title,
    this.isEnable=false
  });
  final TextEditingController controller;
  final String title;

  final GlobalKey myKey;
final bool isEnable;
  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: myKey,
      child: TextFormField(
        enabled: isEnable,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field should not be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          // suffixIcon: Icon(Icons.calendar_month, color: Colors.white),
          label: Text(title, style: const TextStyle(color: Colors.white)),
      
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
