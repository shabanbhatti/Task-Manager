import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateNotifierProvider.autoDispose<
  DateStateNotifier,
  DateAndTextEditingController
>((ref) {
  return DateStateNotifier();
});

class DateStateNotifier extends StateNotifier<DateAndTextEditingController> {
  DateStateNotifier()
    : super(
        DateAndTextEditingController(
          controller: TextEditingController(),
          dateTime: DateTime.now(),
        ),
      );

  void equalToTime(DateTime? value) {
    if (value != null) {
      final dateStr =
          '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
      // print(dateStr);

      state.controller.text = dateStr;
      state = state.copyWith(dateTime: value);
    }
  }


  void foo(String value){

state.controller.text= value;
  }
}

class DateAndTextEditingController {
  final TextEditingController controller;
  final DateTime dateTime;

  const DateAndTextEditingController({
    required this.controller,
    required this.dateTime,
  });

  DateAndTextEditingController copyWith({
    TextEditingController? controller,
    DateTime? dateTime,
  }) {
    return DateAndTextEditingController(
      controller: controller ?? this.controller,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
