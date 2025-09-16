
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/services/database_service.dart';

final searchListProvider =
    StateNotifierProvider.autoDispose<SearchListStateNotifier, List<Tasks>>((
      ref,
    ) {
      return SearchListStateNotifier();
    });

class SearchListStateNotifier extends StateNotifier<List<Tasks>> {
  final Db db = Db();
  SearchListStateNotifier() : super([]);

  Future<void> searchListMethod() async {
    var dataList = await db.fetchTasks();

    var updated = dataList.where((element) => element.isCompleted == false);

    state = [...updated];
  }

  void remove(int index) {
    final list = [...state];
    list.removeAt(index);
    state = list;
  }

  Future<void> onCheck(bool value, Tasks tasks) async {
    if (value) {
      final list = [...state];

      list.removeWhere(
        (element) => element.taskPrimaryKey == tasks.taskPrimaryKey,
      );

      state = list;
    }
  }

  Future<void> onChanged(String word) async {
    final list = await db.fetchTasks();

    final onlyChecked = list.where((element) => element.isCompleted == false);

    state =
        onlyChecked
            .where(
              (element) =>
                  element.title!.toLowerCase().startsWith(word.toLowerCase()),
            )
            .toList();
  }
}
