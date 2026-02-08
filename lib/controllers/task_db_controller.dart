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
  TasksStateNotifier() : super(InitialTaskState());

  Future<bool> fetchTasks() async {
    try {
      state = LoadingTaskState();

      var data = await db.fetchTasks();

      var completedList =
          data.where((element) => element.isCompleted == true).toList();

      var homeList =
          data.where((element) => element.isCompleted == false).toList();
      print(homeList);
      if (homeList.isNotEmpty) {
        state = LoadedTaskSuccessfuly(
          taskList: homeList,
          completedTasks: completedList,
        );
      } else {
        state = EmptyTaskState();
      }

      return true;
    } catch (e) {
      state = ErrorTaskState(error: e.toString());
      return false;
    }
  }

  Future<bool> fetchCompletedTasks() async {
    try {
      state = LoadingTaskState();
      await Future.delayed(const Duration(seconds: 3));
      var data = await db.fetchTasks();

      var completedList =
          data.where((element) => element.isCompleted == true).toList();

      var homeList =
          data.where((element) => element.isCompleted == false).toList();

      if (completedList.isNotEmpty) {
        state = LoadedTaskSuccessfuly(
          taskList: homeList,
          completedTasks: completedList,
        );
      } else {
        state = EmptyTaskState();
      }

      return true;
    } catch (e) {
      state = ErrorTaskState(error: e.toString());
      return false;
    }
  }

  Future<int> insertTask(Tasks tasks) async {
    try {
      state = LoadingTaskState();

      var id = await db.insertTask(tasks);

      await fetchTasks();

      return id;
    } catch (e) {
      state = ErrorTaskState(error: e.toString());
      return 0;
    }
  }

  Future<bool> updateTask(Tasks tasks) async {
    try {
      state = LoadingTaskState();

      var data = await db.updateTask(tasks);

      if (data) {
        await fetchTasks();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      state = ErrorTaskState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(Tasks tasks) async {
    try {
      state = LoadingTaskState();

      var isDeleted = await db.deleteTask(tasks);

      if (isDeleted) {
        // await fetchCompletedTasks();
        await fetchTasks();
        return true;
      } else {
        throw Exception('Not Deleted');
      }
    } catch (e) {
      state = ErrorTaskState(error: e.toString());
      return false;
    }
  }

  Future<void> onChangedCheckBoxButton(bool value, Tasks task) async {
    final updatedTask = task.copyWith(isCompleted: value);
    final success = await db.updateTask(updatedTask);

    if (success && state is LoadedTaskSuccessfuly) {
      final current = state as LoadedTaskSuccessfuly;

      final allTasks = [...current.taskList, ...current.completedTasks];

      final updatedList =
          allTasks.map((t) {
            return t.taskPrimaryKey == updatedTask.taskPrimaryKey
                ? updatedTask
                : t;
          }).toList();

      final homeList = updatedList.where((e) => !e.isCompleted!).toList();
      final completedList = updatedList.where((e) => e.isCompleted!).toList();

      state = LoadedTaskSuccessfuly(
        taskList: homeList,
        completedTasks: completedList,
      );
    }
  }
}

sealed class TasksState {
  const TasksState();
}

class InitialTaskState extends TasksState {
  const InitialTaskState();
}

class LoadingTaskState extends TasksState {
  const LoadingTaskState();
}

class LoadedTaskSuccessfuly extends TasksState {
  final List<Tasks> taskList;
  final List<Tasks> completedTasks;
  const LoadedTaskSuccessfuly({
    required this.taskList,
    required this.completedTasks,
  });
}

class ErrorTaskState extends TasksState {
  final String error;
  const ErrorTaskState({required this.error});
}

class EmptyTaskState extends TasksState {
  const EmptyTaskState();
}
