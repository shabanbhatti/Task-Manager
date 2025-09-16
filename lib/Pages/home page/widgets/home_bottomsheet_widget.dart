import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/user_model.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/shared_pref_service.dart';
import 'package:task_manager_project/widgets/custom_btn.dart';
import 'package:task_manager_project/widgets/text%20field%20widgets/custom_textfield_widget.dart';

class ShowBottomSheetWidgets extends StatefulWidget {
  const ShowBottomSheetWidgets({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<ShowBottomSheetWidgets> createState() => _ShowBottomSheetWidgetsState();
}

class _ShowBottomSheetWidgetsState extends State<ShowBottomSheetWidgets> {
  final nameFocusNode = FocusNode();
  final nicknameFocusNode = FocusNode();
  final ageFocusNode = FocusNode();
  final buttonFocusNode = FocusNode();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final nicknameController = TextEditingController();
  final occupationController = TextEditingController();
  final nameKey = GlobalKey<FormState>();
  final ageKey = GlobalKey<FormState>();
  final nicknameKey = GlobalKey<FormState>();
  final occupationKey = GlobalKey<FormState>();
  final occupaionFocusNode = FocusNode();
  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nicknameController.dispose();
    occupationController.dispose();
    super.dispose();
  }

  // late Size mqSize;
  @override
  Widget build(BuildContext context) {
    print('Bottom sheet build called');
    //  mqSize= mediaQuery(context);//
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextfieldWidget(
                focusNode: nameFocusNode,
                controller: nameController,
                globalKey: nameKey,
                onFieldSubmitted: (p0) {
                  FocusScope.of(context).requestFocus(nicknameFocusNode);
                },
                title: 'Name',
              ),
              const SizedBox(height: 10),
              CustomTextfieldWidget(
                focusNode: nicknameFocusNode,
                controller: nicknameController,
                globalKey: nicknameKey,
                onFieldSubmitted: (p0) {
                  FocusScope.of(context).requestFocus(ageFocusNode);
                },
                title: 'Nickname',
              ),
              const SizedBox(height: 10),
              CustomTextfieldWidget(
                focusNode: occupaionFocusNode,
                controller: occupationController,
                globalKey: occupationKey,
                onFieldSubmitted: (p0) {
                  FocusScope.of(context).requestFocus(ageFocusNode);
                },
                title: 'Occupation',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    flex: 7,
                    child: Form(
                      key: ageKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field shouldn't be empty.";
                          } else {
                            return null;
                          }
                        },
                        controller: ageController,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(buttonFocusNode);
                        },
                        focusNode: ageFocusNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly,
                        ],

                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: 'Age',
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                          fillColor: Colors.grey.withAlpha(120),
                          filled: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),

                  Expanded(
                    flex: 9,
                    child: Consumer(
                      builder: (context, refx, child) {
                        var selection= refx.watch(selectionBtnProvider);
                        var color= refx.watch(nonSelectionErrorProvider);
                        return Wrap(
                          spacing: 10,
                          children:
                              ['Male', 'Female'].map((gender) {
                                return Material(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ChoiceChip(
                                    showCheckmark: false,

                                    selectedColor: Colors.orange,
                                    backgroundColor: color,
                                    label: Text(
                                      gender,
                                      style: TextStyle(
                                        color:Colors.white
                                      ),
                                    ),
                                    selected:selection==gender,
                                    onSelected: (bool selected) {
                                      refx.invalidate(nonSelectionErrorProvider);
                                      refx.read(selectionBtnProvider.notifier).onSelect(selected, gender);
                                      // refx
                                      //     .read(selectionBtnProvider.notifier)
                                      //     .onSelected(selected, gender);
                                    },
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var mqSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return SizedBox(
                      width: mqSize.width * 0.9,
                      child: Consumer(
                        builder:
                            (context, ref, child) => CustomBtn(
                              onTap: () async {
                                var isNameValidate =
                                    nameKey.currentState!.validate();
                                var isNicknameValidate =
                                    nicknameKey.currentState!.validate();
                                var isAgeValidate =
                                    ageKey.currentState!.validate();
                                var isOccupationValidate =
                                    occupationKey.currentState!.validate();
                                if (isNameValidate &&
                                    isNicknameValidate &&
                                    isAgeValidate &&
                                    isOccupationValidate &&
                                    ref.watch(selectionBtnProvider) != '') {
                                  SharedPrefService.setBool(
                                    SharedPrefService.isUserIdentifiedKEY,
                                    true,
                                  );
                                  ref
                                      .read(userDatabaseProvider.notifier)
                                      .insertUser(
                                        User(
                                          nickName: nicknameController.text,
                                          age: ageController.text,
                                          gender: ref.read(
                                            selectionBtnProvider,
                                          ),
                                          userName: nameController.text,
                                          occupation: occupationController.text,
                                        ),
                                      )
                                      .then((value) {
                                        Navigator.pop(context);
                                      });
                                } else {
                                  if (ref.watch(selectionBtnProvider) == '') {
                                    var value= ref.watch(selectionBtnProvider);
                                    ref
                                        .read(
                                          nonSelectionErrorProvider.notifier).onSelect(value);
                                  }
                                }
                              },
                              text: 'Save',
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
