import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/add%20task%20page/widgets/add_task_btn_widget.dart';
import 'package:task_manager_project/Pages/add%20task%20page/widgets/add_task_sliver_appbar_widget.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  static const pageName = '/add_task';

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final titleFormKey = GlobalKey<FormState>();
  final dateFormKey = GlobalKey<FormState>();
  final timeFormKey = GlobalKey<FormState>();
  final descrptionController = TextEditingController();
  final descrptionFormKey = GlobalKey<FormState>();
  late Size mqSize;
  late AnimationController controller;

  late Animation<Offset> scale;
  late DateTime dateTime;
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    scale = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset(0, 0),
    ).animate(controller);

    controller.forward();
  }

  String get dateFormat =>
      '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    print('Create task build called');

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppbarCreateTask(
              dateTimeFormKey: dateFormKey,
              titleController: titleController,
              titleFormKey: titleFormKey,
              timeFormKey: timeFormKey,
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: SlideTransition(
                  position: scale,
                  child: Column(
                    children: [
                      Form(
                        key: descrptionFormKey,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            mqSize = Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            );
                            return SizedBox(
                              width: mqSize.width,
                              child: TextFormField(
                                maxLength: null,
                                maxLines: null,

                                controller: descrptionController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field should not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: Text(
                                    'Description',
                                    style: TextStyle(color: Colors.grey),
                                  ),

                                  border: const UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Importance',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Consumer(
                        builder: (context, refx, child) {
                          var selection = refx.watch(selectionBtnProvider);
                          var color = refx.watch(nonSelectionErrorProvider);
                          print(selection);
                          return Wrap(
                            spacing: 10,
                            children:
                                ['High', 'Low'].map((priority) {
                                  return SizedBox(
                                    width: 140,

                                    child: ChoiceChip(
                                      showCheckmark: false,
                                      selectedColor: Colors.orange,
                                      backgroundColor: color,
                                      label: Center(
                                        child: Text(
                                          priority,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      selected: selection == priority,
                                      // refx.watch(showModelSheetProvider) ==
                                      // priority,
                                      onSelected: (bool selected) {
                                        refx.invalidate(
                                          nonSelectionErrorProvider,
                                        );
                                        refx
                                            .read(selectionBtnProvider.notifier)
                                            .onSelect(selected, priority);
                                        // refx
                                        //     .read(
                                        //       showModelSheetProvider.notifier,
                                        //     )
                                        //     .onSelected(selected, priority);
                                      },
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: AddTaskBtnWidget(
                          titleFormKey: titleFormKey,
                          timeFormKey: timeFormKey,
                          descrptionFormKey: descrptionFormKey,
                          titleController: titleController,
                          descrptionController: descrptionController,
                          dateTime: dateTime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
