import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager_project/Models/user_model.dart';
import 'package:task_manager_project/services/database_service.dart';

final userDatabaseProvider =
    StateNotifierProvider<UserDbStateNotifier, UserState>((ref) {
      return UserDbStateNotifier();
    });

class UserDbStateNotifier extends StateNotifier<UserState> {
  Db db = Db();
  UserDbStateNotifier() : super(InitialUserState());

  Future<void> fetchUser() async {
    try {
      state = LoadingUserState();

      var data = await db.fetchUser();

      if (data.primaryKey != 0) {
        state = LoadedUserSuccessfuly(user: data);
      } else {
        state = EmptyUserState();
      }
    } catch (e) {
      state = ErrorUserState(error: e.toString());
    }
  }

  Future<void> insertUser(User user) async {
    try {
      state = LoadingUserState();

      await db.insertUser(user);

      state = LoadedUserSuccessfuly(user: user);
      await fetchUser();
    } catch (e) {
      state = ErrorUserState(error: e.toString());
    }
  }

  Future<void> updateUser(User user) async {
    try {
      state = LoadingUserState();

      await db.updateUser(user);

      state = LoadedUserSuccessfuly(user: user);
      await fetchUser();
    } catch (e) {
      state = ErrorUserState(error: e.toString());
    }
  }
}

sealed class UserState {
  const UserState();
}

class InitialUserState extends UserState {
  const InitialUserState();
}

class LoadingUserState extends UserState {
  const LoadingUserState();
}

class LoadedUserSuccessfuly extends UserState {
  final User user;
  const LoadedUserSuccessfuly({required this.user});
}

class ErrorUserState extends UserState {
  final String error;
  const ErrorUserState({required this.error});
}

class EmptyUserState extends UserState {
  const EmptyUserState();
}
