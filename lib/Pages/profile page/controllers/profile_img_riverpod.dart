import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:task_manager_project/services/database_service.dart';

final circleAvatarImgProvider = StateNotifierProvider<CircleAvatarImageStateNotifier, String>((ref) {
  return CircleAvatarImageStateNotifier();
});

class CircleAvatarImageStateNotifier extends StateNotifier<String> {
  CircleAvatarImageStateNotifier() : super('');

final ImagePicker imagePicker = ImagePicker();
Future<void> takeImage(ImageSource source)async{
final Db db =Db();

var result = await imagePicker.pickImage(source: source);

if (result!=null) {
  state= result.path;

  final user=await db.fetchUser();
  await db.updateUser(user.copyWith(imgPath: state));

  await db.fetchUser();
}

}

}