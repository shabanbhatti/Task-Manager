import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/controllers/date%20time%20controllers/date_riverpod.dart';
import 'package:task_manager_project/controllers/date%20time%20controllers/time_riverpod.dart';
import 'package:task_manager_project/widgets/text%20field%20widgets/custom_date_time_textfield_widget.dart';
import 'package:task_manager_project/widgets/text%20field%20widgets/custom_textfield_widget.dart';

class UpdateTaskSliverAppBar extends StatefulWidget {
  const UpdateTaskSliverAppBar({
    super.key,
    required this.titleController,
    required this.titleFormKey,
    required this.dateTimeFormKey,
    required this.timeFormKey,
  });
  final titleController;
  final titleFormKey;
  final dateTimeFormKey;
  final timeFormKey;

  @override
  State<UpdateTaskSliverAppBar> createState() => _UpdateTaskSliverAppBarState();
}

class _UpdateTaskSliverAppBarState extends State<UpdateTaskSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text(
        'Update your task',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
      ),
      expandedHeight: 350,
      snap: true,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SafeArea(
                minimum: EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // -----------------TITLE CONTROLLER-------------
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: CustomTextfieldWidget(
                        controller: widget.titleController,
                        globalKey: widget.titleFormKey,
                        title: 'Title',
                        focusNode: FocusNode(),
                        onFieldSubmitted: (p0) => '',
                      ),
                    ),
                    // -----------------DATE CONTROLLER-------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Consumer(
                            builder: (context, dateProviderRef, child) {
                              return InkWell(
                                onTap: () async {
                                  var myDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2025),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ),
                                  );
                                  dateProviderRef
                                      .read(dateProvider.notifier)
                                      .equalToTime(myDate);
                                },
                                child: DateTimeTextFormField(
                                  controller: dateProviderRef.watch(
                                    dateProvider.select(
                                      (value) => value.controller,
                                    ),
                                  ),
                                  myKey: widget.dateTimeFormKey,

                                  title: 'Due Date (optional)',
                                ),
                              );
                            },
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Consumer(
                            builder:
                                (context, dateProviderRef, child) => InkWell(
                                  onTap: () async {
                                    var myDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      ),
                                    );
                                    dateProviderRef
                                        .read(dateProvider.notifier)
                                        .equalToTime(myDate);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),

                    // // ---------------TIME--------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Consumer(
                            builder: (context, dateProviderRef, child) {
                              return InkWell(
                                onTap: () async {
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    dateProviderRef
                                        .read(timeProvider.notifier)
                                        .onChangedTime(value);
                                  });
                                },
                                child: DateTimeTextFormField(
                                  controller: dateProviderRef.watch(
                                    timeProvider.select(
                                      (value) => value.controller,
                                    ),
                                  ),
                                  myKey: widget.timeFormKey,

                                  title: 'Time',
                                ),
                                // child: SizedBox(
                                //   width: mqSize.width*0.4,
                                //   child: TimeTextFormField(
                                //     controller: timeRef.watch(timeProvider).controller,
                                //     globalKey: widget.timeFormKey,
                                //     title: 'Due time',
                                //   ),
                                // ),
                              );
                            },
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Consumer(
                            builder:
                                (context, timeRef, child) => InkWell(
                                  onTap: () async {
                                    await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeRef
                                          .read(timeProvider.notifier)
                                          .onChangedTime(value);
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.timer,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
