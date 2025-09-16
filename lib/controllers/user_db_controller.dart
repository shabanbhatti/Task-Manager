import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager_project/Models/user_model.dart';
import 'package:task_manager_project/services/database_service.dart';

final userDatabaseProvider = StateNotifierProvider<UserDbStateNotifier, UserState>((ref) {
  return UserDbStateNotifier();
});

class UserDbStateNotifier extends StateNotifier<UserState> {

Db db = Db() ; 
UserDbStateNotifier(): super(InitialState());

Future<void> fetchUser()async{
try {
  
state= LoadingState();

var data= await db.fetchUser();

if (data.primaryKey!=0) {
  state= LoadedSuccessfuly(user: data);
}else{
state= EmptyState();
}

} catch (e) {
  state= ErrorState(error: e.toString());
}

}


Future<void> insertUser(User user)async{

try {
  state= LoadingState();

await db.insertUser(user);

state= LoadedSuccessfuly(user: user);
await fetchUser();
} catch (e) {
  state= ErrorState(error: e.toString());
}

}


Future<void> updateUser(User user)async{

try {
  state= LoadingState();

 await db.updateUser(user);

state= LoadedSuccessfuly(user: user);
await fetchUser();
} catch (e) {
  state= ErrorState(error: e.toString());
}


}


}




sealed class UserState {
  const UserState();
}
class InitialState extends UserState{
  const InitialState();
}
class LoadingState extends UserState{
  const LoadingState();
}

class LoadedSuccessfuly extends UserState {
  final User user;
  const LoadedSuccessfuly({required this.user});
}

class ErrorState extends UserState {
  final String error;
  const ErrorState({required this.error});
}

class EmptyState extends UserState {
  const EmptyState();
}