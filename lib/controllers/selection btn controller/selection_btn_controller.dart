import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectionBtnProvider =
    StateNotifierProvider.autoDispose<SelectionBtnSTateNotifier, String>((ref) {
      return SelectionBtnSTateNotifier();
    });

class SelectionBtnSTateNotifier extends StateNotifier<String> {
  SelectionBtnSTateNotifier() : super('');

  Future<void> onSelect(bool isTrue, String value) async {
    if (isTrue) {
      state = value;
    }
  }

  Future<void> onInitialState(String value) async {
    state = value;
  }
}
