import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final introPageProvider = StateNotifierProvider<IntroPageStateNotifier, double>((ref) {
  return IntroPageStateNotifier();
});


class IntroPageStateNotifier extends StateNotifier<double> {
  IntroPageStateNotifier(): super(0.0);

void animate(){

Timer.periodic(Duration(milliseconds: 500), (timer) {
  state= state==0.0? 0.05:0.0;
},);

}

}