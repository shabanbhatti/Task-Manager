import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Pages/profile%20page/controllers/profile_noti_switch_riverpod.dart';
import 'package:task_manager_project/Pages/update%20task%20page/widgets/update_btn_widget.dart';
import 'package:task_manager_project/Pages/update%20task%20page/widgets/update_task_sliverappbar_widget.dart';
import 'package:task_manager_project/controllers/date%20time%20controllers/date_riverpod.dart';
import 'package:task_manager_project/controllers/date%20time%20controllers/time_riverpod.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/non_selection_error_color_controller.dart';
import 'package:task_manager_project/controllers/selection%20btn%20controller/selection_btn_controller.dart';

class UpdateTask extends ConsumerStatefulWidget {
  const UpdateTask({super.key, required this.tasks});

  final Tasks tasks;
  static const pageName = '/update_task';

  @override
  ConsumerState<UpdateTask> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<UpdateTask>
    with SingleTickerProviderStateMixin {
  var titleController = TextEditingController();
  final titleFormKey = GlobalKey<FormState>();
  final dateFormKey = GlobalKey<FormState>();
  final timeFormKey = GlobalKey<FormState>();
  var descrptionController = TextEditingController();
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

    titleController.text = widget.tasks.title.toString();
    descrptionController.text = widget.tasks.description.toString();
    Future.microtask(() {
      ref
          .read(selectionBtnProvider.notifier).onInitialState(widget.tasks.importance??'');
          ref.read(dateProvider.notifier).foo(widget.tasks.date.toString());
          ref.read(timeProvider.notifier).foo(widget.tasks.time.toString());
          
    });

  }

  @override
  void dispose() {
    titleController.dispose();
    descrptionController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('update task build called');

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            UpdateTaskSliverAppBar(
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
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                          ),
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
                          var selection= refx.watch(selectionBtnProvider);
                          var color= refx.watch(nonSelectionErrorProvider);
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
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                      selected:
                                         selection ==
                                          priority,
                                      onSelected: (bool selected) {
                                        refx.invalidate(nonSelectionErrorProvider);
                                       refx.read(selectionBtnProvider.notifier).onSelect(selected, priority);
                                      },
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: UpdateBtnWidget(
                          titleFormKey: titleFormKey,
                          timeFormKey: timeFormKey,
                          descrptionFormKey: descrptionFormKey,
                          tasks: widget.tasks,
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
