import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nonSelectionErrorProvider =
    StateNotifierProvider.autoDispose<SelectionBtnSTateNotifier, Color>((ref) {
      return SelectionBtnSTateNotifier();
    });

class SelectionBtnSTateNotifier extends StateNotifier<Color> {
  SelectionBtnSTateNotifier() : super(Colors.grey.withAlpha(120));

  Future<void> onSelect(String value) async {
    if (value == '') {
      state = const Color.fromARGB(255, 186, 46, 36);
    } else {
      state = Colors.grey.withAlpha(120);
    }
  }
}
