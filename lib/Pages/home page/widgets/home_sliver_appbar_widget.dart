import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager_project/Pages/profile%20page/profile_page.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/search_tasks_page.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';
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
    print('Sliver app bar');
    return SliverAppBar(
      expandedHeight: 220,
      leading: Consumer(
        builder: (context, x, child) {
          var userRef = x.watch(userDatabaseProvider);
          if (userRef is InitialState) {
            return IconButton(
              onPressed: () {
                useregistrationModelBottomSheet(context);
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          } else if (userRef is LoadingState) {
            return IconButton(
              onPressed: () {
                useregistrationModelBottomSheet(context);
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          } else if (userRef is LoadedSuccessfuly) {
            return IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UserDetailPage.pageName);
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          } else {
            return IconButton(
              onPressed: () {
                useregistrationModelBottomSheet(context);
              },
              icon: Icon(Icons.menu, color: Colors.white),
            );
          }
        },
      ),

      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => SearchPage()),
                  );
                },
                icon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(-0.95, 0.46),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Consumer(
                          builder: (context, userRef, child) {
                            var x = userRef.watch(userDatabaseProvider);
                            return InkWell(
                              onTap: () {
                                if (x is InitialState) {
                                  print('initial');
                                  useregistrationModelBottomSheet(context);
                                } else if (x is LoadingState) {
                                  print('loading');
                                  useregistrationModelBottomSheet(context);
                                } else if (x is LoadedSuccessfuly) {
                                  print('successfuly');
                                  viewOrSetImage(context);
                                } else if (x is ErrorState) {
                                  print('error');
                                  useregistrationModelBottomSheet(context);
                                } else if (x is EmptyState) {
                                  print('empty');
                                  useregistrationModelBottomSheet(context);
                                }
                              },
                              onLongPress: () {
                                showCupertinoDialog(
                                  barrierDismissible: true,

                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        shape: CircleBorder(),

                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InteractiveViewer(
                                              maxScale: 10,
                                              minScale: 0.1,
                                              child: Container(
                                                child: switch (userRef.watch(
                                                  userDatabaseProvider,
                                                )) {
                                                  InitialState() => Image.asset(
                                                    loadingImgPath,
                                                    height: 300,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                  LoadingState() => Image.asset(
                                                    loadingImgPath,
                                                    height: 300,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                  LoadedSuccessfuly(
                                                    user: var user,
                                                  ) =>
                                                    (user.imgPath == null)
                                                        ? Image.asset(
                                                          cameraIconImgPath,
                                                          height: 300,
                                                          fit: BoxFit.fitHeight,
                                                        )
                                                        : Image.file(
                                                          File(user.imgPath!),
                                                          height: 300,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                  ErrorState(
                                                    error: var error,
                                                  ) =>
                                                    Image.asset(
                                                      cameraIconImgPath,
                                                      height: 300,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  EmptyState() => Image.asset(
                                                    cameraIconImgPath,
                                                    height: 300,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                );
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
                                  builder:
                                      (context, userRef, child) => CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.grey.withAlpha(
                                          200,
                                        ),
                                        backgroundImage: switch (userRef.watch(
                                          userDatabaseProvider,
                                        )) {
                                          InitialState() => const AssetImage(
                                            settingsIconImgPath,
                                          ),
                                          LoadingState() => const AssetImage(
                                            loadingImgPath,
                                          ),
                                          LoadedSuccessfuly(user: var user) =>
                                            (user.imgPath == null)
                                                ? AssetImage(cameraIconImgPath)
                                                : FileImage(
                                                  File(user.imgPath!),
                                                ),
                                          ErrorState(error: var error) =>
                                            const AssetImage(cameraIconImgPath),
                                          EmptyState() => const AssetImage(
                                            cameraIconImgPath,
                                          ),
                                        },
                                        child:
                                            (userRef.watch(
                                                      userDatabaseProvider,
                                                    ) ==
                                                    InitialState())
                                                ? Icon(CupertinoIcons.camera)
                                                : (userRef.watch(
                                                      userDatabaseProvider,
                                                    ) ==
                                                    LoadingState())
                                                ? const CupertinoActivityIndicator()
                                                : null,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer(
                              builder:
                                  (context, userRef, child) => switch (userRef
                                      .watch(userDatabaseProvider)) {
                                    InitialState() => const Text(
                                      'No username',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    LoadingState() => Skeletonizer(
                                      child: const Text(
                                        'Username here it is',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    LoadedSuccessfuly(user: var user) => Text(
                                      user.userName ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ErrorState(error: var error) => Text(
                                      'No username',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    EmptyState() => Text(
                                      'No username',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  },
                            ),

                            Consumer(
                              builder:
                                  (context, userRef, child) => switch (userRef
                                      .watch(userDatabaseProvider)) {
                                    InitialState() => const Text(
                                      'No Occupation',
                                      style: TextStyle(
                                        fontSize: 13,
                                         color: const Color.fromARGB(
                                          255,
                                          215,
                                          215,
                                          215,
                                        ),
                                      ),
                                    ),
                                    LoadingState() => const Skeletonizer(
                                      child: Text(
                                        'Username here it is',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: const Color.fromARGB(
                                          255,
                                          215,
                                          215,
                                          215,
                                        ),
                                        ),
                                      ),
                                    ),
                                    LoadedSuccessfuly(user: var user) => Text(
                                      user.occupation ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,

                                        color: const Color.fromARGB(
                                          255,
                                          215,
                                          215,
                                          215,
                                        ),
                                      ),
                                    ),
                                    ErrorState(error: var error) => Text(
                                      'No Occupation',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                          255,
                                          215,
                                          215,
                                          215,
                                        ),
                                      ),
                                    ),
                                    EmptyState() => Text(
                                      'No Occupation',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                          255,
                                          215,
                                          215,
                                          215,
                                        ),
                                      ),
                                    ),
                                  },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
