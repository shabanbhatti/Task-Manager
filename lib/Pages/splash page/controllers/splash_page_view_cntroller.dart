import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageviewNavigateProvider =
    StateNotifierProvider<PageviewNavigateStateProvider, int>((ref) {
      return PageviewNavigateStateProvider();
    });

class PageviewNavigateStateProvider extends StateNotifier<int> {
  PageviewNavigateStateProvider() : super(0);

  void pageviewNavigate() {
    state = state + 1;
  }
}
