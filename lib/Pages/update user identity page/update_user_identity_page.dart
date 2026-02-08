import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/update%20user%20identity%20page/widgets/update_user_identity_btn.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/database_service.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';
import 'package:task_manager_project/widgets/text%20field%20widgets/custom_textfield_widget.dart';

class UpdateButton extends ConsumerStatefulWidget {
  const UpdateButton({super.key});
  static const pageName = '/update_buttonn';

  @override
  ConsumerState<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends ConsumerState<UpdateButton>
    with SingleTickerProviderStateMixin {
  final nameFocusNode = FocusNode();

  final nicknameFocusNode = FocusNode();

  final ageFocusNode = FocusNode();

  final buttonFocusNode = FocusNode();

  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final nicknameController = TextEditingController();

  final nameKey = GlobalKey<FormState>();

  final ageKey = GlobalKey<FormState>();

  final nicknameKey = GlobalKey<FormState>();

  final occupationKey = GlobalKey<FormState>();

  final occupationController = TextEditingController();

  final occupationFocusNode = FocusNode();
  late AnimationController controller;

  late Animation<Offset> scale;
  Db? db;
  @override
  void initState() {
    super.initState();
    db = Db();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    scale = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset(0, 0),
    ).animate(controller);

    controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userDatabaseProvider.notifier).fetchUser();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    ageController.dispose();

    super.dispose();
  }

  late Size mqSize;
  @override
  Widget build(BuildContext context) {
    print('Updated Build called');
    ref.listen(userDatabaseProvider, (previous, next) {
      if (next is LoadedUserSuccessfuly) {
        nameController.text = next.user.userName ?? '';
        nicknameController.text = next.user.nickName ?? '';
        occupationController.text = next.user.occupation ?? '';
        ageController.text = next.user.age ?? '';
        ref
            .read(selectionBtnProvider.notifier)
            .onSelect(true, next.user.gender ?? '');
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: const GradientsBackgroundAppbarWidget(),
          centerTitle: true,
          title: const Text(
            'Update',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: SlideTransition(
          position: scale,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextfieldWidget(
                    focusNode: nameFocusNode,
                    controller: nameController,
                    globalKey: nameKey,
                    onFieldSubmitted: (p0) {
                      FocusScope.of(context).requestFocus(nicknameFocusNode);
                    },
                    title: 'Name',
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextfieldWidget(
                  focusNode: nicknameFocusNode,
                  controller: nicknameController,
                  globalKey: nicknameKey,
                  onFieldSubmitted: (p0) {
                    FocusScope.of(context).requestFocus(ageFocusNode);
                  },
                  title: 'Nickname',
                ),

                const SizedBox(height: 15),

                CustomTextfieldWidget(
                  focusNode: occupationFocusNode,
                  controller: occupationController,
                  globalKey: occupationKey,
                  onFieldSubmitted: (p0) {
                    FocusScope.of(context).requestFocus(ageFocusNode);
                  },
                  title: 'Occupation',
                ),

                const SizedBox(height: 15),
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
                            FocusScope.of(
                              context,
                            ).requestFocus(buttonFocusNode);
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
                      flex: 7,
                      child: Consumer(
                        builder: (context, ref, child) {
                          var color = ref.watch(nonSelectionErrorProvider);
                          var selection = ref.watch(selectionBtnProvider);
                          return Wrap(
                            spacing: 10,
                            children:
                                ['Male', 'Female'].map((gender) {
                                  return ChoiceChip(
                                    showCheckmark: false,

                                    selectedColor: Colors.orange,
                                    backgroundColor: color,
                                    label: Text(
                                      gender,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    selected: selection == gender,
                                    onSelected: (bool selected) {
                                      ref.invalidate(nonSelectionErrorProvider);
                                      ref
                                          .read(selectionBtnProvider.notifier)
                                          .onSelect(selected, gender);
                                    },
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: UpdateUserIdentityBtn(
                      db: db!,
                      nicknameController: nicknameController,
                      ageController: ageController,
                      nameController: nameController,
                      occupationController: occupationController,
                      ageKey: ageKey,
                      nameKey: nameKey,
                      nicknameKey: nicknameKey,
                      occupationKey: occupationKey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
