import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';

final completedTasksListProvider = StateNotifierProvider<CompletedTaskListStateNotifier, List>((ref) {
  return CompletedTaskListStateNotifier();
});


class CompletedTaskListStateNotifier extends StateNotifier<List<Tasks>> {
  CompletedTaskListStateNotifier(): super([]);


void addTaskToCompletedList(bool value, Tasks task){

if(value){

state=[...state, task];
print(state);
}else{
  state= state.where((element) => element.taskPrimaryKey!=task.taskPrimaryKey,).toList();
  print('Removed: ${state}');
}

}

}