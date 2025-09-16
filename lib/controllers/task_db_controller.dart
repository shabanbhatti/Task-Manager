import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/services/database_service.dart';

final tasksProvider = StateNotifierProvider<TasksStateNotifier, TasksState>((
  ref,
) {
  return TasksStateNotifier();
});

class TasksStateNotifier extends StateNotifier<TasksState> {
  final Db db = Db();
  TasksStateNotifier() : super(InitialState());

  Future<bool> fetchTasks() async {
    try {
      state = LoadingState();
      var data = await db.fetchTasks();

      var completedList =
          data.where((element) => element.isCompleted == true).toList();

      var homeList =
          data.where((element) => element.isCompleted == false).toList();
print(homeList);
      if (homeList.isNotEmpty) {
        state = LoadedSuccessfuly(
          taskList: homeList,
          completedTasks: completedList,
        );
      } else {
        state = EmptyState();
      }

      return true;
    } catch (e) {
      state = ErrorState(error: e.toString());
      return false;
    }
  }

  Future<bool> fetchCompletedTasks() async {
    try {
      state = LoadingState();
      var data = await db.fetchTasks();

      var completedList =
          data.where((element) => element.isCompleted == true).toList();

      var homeList =
          data.where((element) => element.isCompleted == false).toList();

      if (completedList.isNotEmpty) {
        state = LoadedSuccessfuly(
          taskList: homeList,
          completedTasks: completedList,
        );
      } else {
        state = EmptyState();
      }

      return true;
    } catch (e) {
      state = ErrorState(error: e.toString());
      return false;
    }
  }

  Future<int> insertTask(Tasks tasks) async {
    try {
      state = LoadingState();

      var id= await db.insertTask(tasks);

      await fetchTasks();

      return id;
    } catch (e) {
      state = ErrorState(error: e.toString());
      return 0;
    }
  }

  Future<bool> updateTask(Tasks tasks) async {
    try {
      state = LoadingState();

      var data = await db.updateTask(tasks);

      if (data) {
        await fetchTasks();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      state = ErrorState(error: e.toString());
      return false;
    }
  }

Future<bool> deleteTask(Tasks tasks)async{

try {
  state= LoadingState();

var isDeleted= await db.deleteTask(tasks);

if (isDeleted) {
  await fetchCompletedTasks();
  await fetchTasks();
return true;
}else{
  throw Exception('Not Deleted');
}

} catch (e) {
  state= ErrorState(error: e.toString());
  return false;
}

}


  Future<void> onChangedCheckBoxButton(bool value, Tasks task) async {
    final updatedTask = task.copyWith(isCompleted: value);
    final success = await db.updateTask(updatedTask);

    if (success && state is LoadedSuccessfuly) {
      final current = state as LoadedSuccessfuly;

      final allTasks = [...current.taskList, ...current.completedTasks];

      print('$allTasks=========');
      final updatedList =
          allTasks.map((t) {
            return t.taskPrimaryKey == updatedTask.taskPrimaryKey
                ? updatedTask
                : t;
          }).toList();

      final homeList = updatedList.where((e) => !e.isCompleted!).toList();
      final completedList = updatedList.where((e) => e.isCompleted!).toList();

      state = LoadedSuccessfuly(
        taskList: homeList,
        completedTasks: completedList,
      );
    }
  }
}

sealed class TasksState {
  const TasksState();
}

class InitialState extends TasksState {
  const InitialState();
}

class LoadingState extends TasksState {
  const LoadingState();
}

class LoadedSuccessfuly extends TasksState {
  final List<Tasks> taskList;
  final List<Tasks> completedTasks;
  const LoadedSuccessfuly({
    required this.taskList,
    required this.completedTasks,
  });
}

class ErrorState extends TasksState {
  final String error;
  const ErrorState({required this.error});
}

class EmptyState extends TasksState {
  const EmptyState();
}
