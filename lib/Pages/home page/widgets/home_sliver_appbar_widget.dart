import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager_project/Pages/profile%20page/profile_page.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/search_tasks_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';
import 'package:task_manager_project/utils/dialog%20boxes/view_img_dialog.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/user_registration_model_bottom_sheet.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/view_or_set_img_model_bottom_sheet.dart';

class MyTopWidget extends ConsumerStatefulWidget {
  const MyTopWidget({super.key});

  @override
  ConsumerState<MyTopWidget> createState() => _MyTopWidgetState();
}

class _MyTopWidgetState extends ConsumerState<MyTopWidget> {
  @override
  Widget build(BuildContext context) {
    print('Top widget called');
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        var user = ref.read(userDatabaseProvider);
                        if (user is LoadedUserSuccessfuly) {
                          Navigator.of(context).pushNamed(ProfilePage.pageName);
                        } else {
                          useregistrationModelBottomSheet(context);
                        }
                      },
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(SearchPage.pageName);
                      },
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 30),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Consumer(
                        builder: (context, userRef, child) {
                          return GestureDetector(
                            onTap: () {
                              var userState = ref.read(userDatabaseProvider);
                              if (userState is LoadedUserSuccessfuly) {
                                print('successfuly');
                                viewOrSetImage(context);
                              } else {
                                print('error');
                                useregistrationModelBottomSheet(context);
                              }
                            },
                            onLongPress: () {
                              viewImgDialog(context);
                            },
                            child: Hero(
                              tag: 'circle_img',
                              placeholderBuilder:
                                  (context, heroSize, child) => CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey,
                                  ),
                              flightShuttleBuilder:
                                  (
                                    flightContext,
                                    animation,
                                    flightDirection,
                                    fromHeroContext,
                                    toHeroContext,
                                  ) => RotationTransition(
                                    turns: animation.drive(
                                      Tween(begin: 0.0, end: 1),
                                    ),
                                    child: fromHeroContext.widget,
                                  ),
                              child: Consumer(
                                builder: (context, userRef, child) {
                                  var user = userRef.watch(
                                    userDatabaseProvider,
                                  );
                                  if (user is LoadingUserState) {
                                    return const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        loadingImgPath,
                                      ),
                                    );
                                  } else if (user is LoadedUserSuccessfuly) {
                                    if (user.user.imgPath != null) {
                                      return CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(
                                          File(user.user.imgPath!),
                                        ),
                                      );
                                    } else {
                                      return const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                          cameraIconImgPath,
                                        ),
                                      );
                                    }
                                  } else {
                                    return const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: const AssetImage(
                                        cameraIconImgPath,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Expanded(
                      flex: 13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer(
                            builder: (context, x, child) {
                              var userRef = x.watch(userDatabaseProvider);
                              if (userRef is LoadingUserState) {
                                return const Skeletonizer(
                                  child: Text(
                                    'Username here it is',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else if (userRef is LoadedUserSuccessfuly) {
                                var user = userRef.user;
                                return Text(
                                  user.userName ?? '',

                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return const Text(
                                  'No Username',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),

                          Consumer(
                            builder: (context, x, child) {
                              var userRef = x.watch(userDatabaseProvider);
                              if (userRef is LoadingUserState) {
                                return const Skeletonizer(
                                  child: Text(
                                    'Occupation here it is',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else if (userRef is LoadedUserSuccessfuly) {
                                var user = userRef.user;
                                return Text(
                                  user.occupation ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return const Text(
                                  'No Occupation',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: TabBar(
                unselectedLabelColor: Colors.white.withAlpha(150),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'All Tasks'),
                  Consumer(
                    builder: (context, y, _) {
                      var taskState = y.watch(tasksProvider);
                      if (taskState is LoadedTaskSuccessfuly) {
                        return Badge(
                          label: Text(taskState.taskList.length.toString()),
                          child: Tab(text: 'Pendings'),
                        );
                      } else {
                        return Badge(
                          label: Text('0'),
                          child: Tab(text: 'Pendings'),
                        );
                      }
                    },
                  ),

                  Consumer(
                    builder: (context, y, _) {
                      var taskState = y.watch(tasksProvider);
                      if (taskState is LoadedTaskSuccessfuly) {
                        return Badge(
                          label: Text(
                            taskState.completedTasks.length.toString(),
                          ),
                          child: Tab(text: 'Completed'),
                        );
                      } else {
                        return Badge(
                          label: Text('0'),
                          child: Tab(text: 'Completed'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
