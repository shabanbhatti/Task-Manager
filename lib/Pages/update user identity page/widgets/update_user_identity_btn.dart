import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/database_service.dart';
import 'package:task_manager_project/widgets/custom_btn.dart';

class UpdateUserIdentityBtn extends StatelessWidget {
  const UpdateUserIdentityBtn({super.key, required this.db, required this.nicknameController, required this.ageController, required this.nameController, required this.occupationController, required this.nicknameKey, required this.nameKey, required this.ageKey, required this.occupationKey});
final Db db;
final TextEditingController nicknameController;
final TextEditingController ageController;
final TextEditingController nameController;
final TextEditingController occupationController;
final GlobalKey<FormState> nicknameKey;
final GlobalKey<FormState> nameKey;
final GlobalKey<FormState> ageKey;
final GlobalKey<FormState> occupationKey;
  @override
  Widget build(BuildContext context) {
    return  Consumer(
                          builder:
                              (
                                context,
                                ref,
                                child,
                              ) => CustomBtn(
                                onTap: () async {
                                  var selection= ref.watch(selectionBtnProvider);
                                var user = await db.fetchUser();
                                var isNameValidate= nameKey.currentState?.validate();
                                var isNicknameValidate= nicknameKey.currentState?.validate();
                                var isAgeValidate= ageKey.currentState?.validate();
                                var isOccupationValidate= occupationKey.currentState?.validate();
                                if (isNameValidate!&&isNicknameValidate!&&isAgeValidate!&&isOccupationValidate!&& selection!='') {
                                  
                              await  ref
                                    .read(userDatabaseProvider.notifier)
                                    .updateUser(
                                      user.copyWith(
                                        nickName:
                                            (nicknameController.text.isEmpty)
                                                ? null
                                                : nicknameController.text,
                                        age:
                                            (ageController.text.isEmpty)
                                                ? null
                                                : ageController.text,
                                        gender:selection,
                                        userName:
                                            (nameController.text.isEmpty)
                                                ? null
                                                : nameController.text,

                                        occupation:
                                            (occupationController.text.isEmpty)
                                                ? null
                                                : occupationController.text,
                                      ),
                                    );
                                    Navigator.pop(context);
                                }else{
                                  if (selection=='') {
                                    ref.read(nonSelectionErrorProvider.notifier).onSelect(selection);
                                  }
                                }
                                    
                              },text: 'Update'),
                        );
  }
}