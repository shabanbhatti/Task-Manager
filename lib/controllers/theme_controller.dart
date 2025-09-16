import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Theme/theme.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';

final themeByRadioProvider =
    StateNotifierProvider<ThemeByRadioStateNotifier, ThemeState>((ref) {
      return ThemeByRadioStateNotifier();
    });

class ThemeByRadioStateNotifier extends StateNotifier<ThemeState> {
  ThemeByRadioStateNotifier()
    : super(ThemeState(groupValue: 'Light', themeData: lightMode));

Future<void> getTheme()async{


var currentTheme=await SharedPrefService.getString(SharedPrefService.themeKEY)??'Light';

if (currentTheme=='Light') {
  state= state.copyWith(groupValue: 'Light' , themeData: lightMode);
}else if(currentTheme=='Dark'){
  state= state.copyWith(groupValue: 'Dark' , themeData: darkMode);
}else{
  state= state.copyWith(groupValue: 'System');
}

}



  void onChanged(String value) async {
    
    state = state.copyWith(groupValue: value);
await SharedPrefService.setString(SharedPrefService.themeKEY, value);

if (value=="Light") {
  state=state.copyWith(themeData: lightMode);
  
}else{
  state=state.copyWith(themeData: darkMode);
}

  }
}

class ThemeState {
  final String groupValue;
  final ThemeData themeData;

  const ThemeState({required this.groupValue, required this.themeData});

  ThemeState copyWith({String? groupValue, ThemeData? themeData}) {
    return ThemeState(
      groupValue: groupValue ?? this.groupValue,
      themeData: themeData ?? this.themeData,
    );
  }
}
