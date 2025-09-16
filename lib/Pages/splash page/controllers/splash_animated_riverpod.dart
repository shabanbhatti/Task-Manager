import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animatedScaleProvider = StateNotifierProvider<AnimatedScaleStateNotifier, double>((ref) {
  return AnimatedScaleStateNotifier();
});

class AnimatedScaleStateNotifier extends StateNotifier<double> {
  Timer? _timer;

  AnimatedScaleStateNotifier() : super(0.9);

  void animate() {
    _timer?.cancel(); 
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      state = (state == 0.9) ? 1.0 : 0.9;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
