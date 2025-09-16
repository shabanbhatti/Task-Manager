import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StateNotifierProvider.autoDispose<TimeStateNotifier, TimeAndTimeTextEditingController>((ref) {
  return TimeStateNotifier();
});

class TimeStateNotifier extends StateNotifier<TimeAndTimeTextEditingController>{
  
TimeStateNotifier(): super(TimeAndTimeTextEditingController(controller: TextEditingController(), timeOfDay: TimeOfDay.now()));

void onChangedTime(TimeOfDay? timeOfDay){

if (timeOfDay!=null) {
  state.controller.text= '${timeOfDay!.hourOfPeriod.toString().padLeft(2,'0')}:${timeOfDay!.minute.toString().padLeft(2,'0')} ${timeOfDay.period==DayPeriod.am?'AM':'PM'}';

state= state.copyWith(timeOfDay: timeOfDay);
}

}


  void foo(String value){

state.controller.text= value;
  }


}

class TimeAndTimeTextEditingController {
  
final TimeOfDay timeOfDay;
final TextEditingController controller;

const TimeAndTimeTextEditingController({required this.controller, required this.timeOfDay});

TimeAndTimeTextEditingController copyWith({TimeOfDay? timeOfDay, TextEditingController? controller}){
return TimeAndTimeTextEditingController(controller: controller??this.controller, timeOfDay: timeOfDay??this.timeOfDay);

}


}