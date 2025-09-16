import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/Pages/profile%20page/controllers/profile_img_riverpod.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  static const pageName = 'user_info';

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    scale = Tween<double>(begin: 0.9, end: 1.0).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back, color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: const GradientsBackgroundAppbarWidget(),
          centerTitle: true,
          title: const Text(
            'User informaion',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: Center(
          child: ScaleTransition(
            scale: scale,
            child: LayoutBuilder(
              builder: (context, constraints) {
                Size mqSize = Size(constraints.maxWidth, constraints.maxHeight);
                return SizedBox(
                  height: mqSize.height * 0.75,
                  width: mqSize.width * 0.95,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.orange],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Consumer(
                              builder:
                                  (context, ref, child) => Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Hero(
                                      tag: 'circle_img',
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.white.withAlpha(
                                          100,
                                        ),
                                        backgroundImage: switch (ref.watch(
                                          userDatabaseProvider,
                                        )) {
                                          InitialState() => const AssetImage(
                                            cameraIconImgPath,
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
                                            (ref.watch(userDatabaseProvider) ==
                                                    InitialState())
                                                ? Icon(CupertinoIcons.camera)
                                                : (ref.watch(
                                                      userDatabaseProvider,
                                                    ) ==
                                                    LoadingState())
                                                ? CupertinoActivityIndicator()
                                                : null,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Consumer(
                              builder:
                                  (context, ref, child) => TextButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                            circleAvatarImgProvider.notifier,
                                          )
                                          .takeImage(ImageSource.gallery)
                                          .then((value) {
                                            ref
                                                .read(
                                                  userDatabaseProvider.notifier,
                                                )
                                                .fetchUser();
                                          });
                                    },
                                    child: Text(
                                      'Change your profile picture',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                          255,
                                          9,
                                          87,
                                          151,
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              shape: Border(bottom: BorderSide(width: 1)),
                              leading: const Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              title: Consumer(
                                builder:
                                    (context, ref, child) => switch (ref.watch(
                                      userDatabaseProvider,
                                    )) {
                                      InitialState() => const Text(
                                        'No Username',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      LoadingState() =>
                                        CupertinoActivityIndicator(),
                                      LoadedSuccessfuly(user: var user) => Text(
                                        user.userName.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      ErrorState(error: var error) => Text(
                                        'No username found',
                                      ),
                                      EmptyState() => Text('No username found'),
                                    },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              shape: Border(bottom: BorderSide(width: 1)),
                              leading: const Text(
                                'Nickname:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              title: Consumer(
                                builder:
                                    (context, ref, child) => switch (ref.watch(
                                      userDatabaseProvider,
                                    )) {
                                      InitialState() => const Text(
                                        'No nickname',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      LoadingState() =>
                                        CupertinoActivityIndicator(),
                                      LoadedSuccessfuly(user: var user) => Text(
                                        user.nickName.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      ErrorState(error: var error) => Text(
                                        'No nickname found',
                                      ),
                                      EmptyState() => Text('No nickname found'),
                                    },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              leading: const Text(
                                'Occupation:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              title: Consumer(
                                builder:
                                    (context, ref, child) => switch (ref.watch(
                                      userDatabaseProvider,
                                    )) {
                                      InitialState() => const Text(
                                        'No Occupation',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      LoadingState() =>
                                        CupertinoActivityIndicator(),
                                      LoadedSuccessfuly(user: var user) => Text(
                                        user.occupation.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      ErrorState(error: var error) => Text(
                                        'No occupation found',
                                      ),
                                      EmptyState() => Text(
                                        'No occupation found',
                                      ),
                                    },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              shape: Border(bottom: BorderSide(width: 1)),
                              leading: const Text(
                                'Gender:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              title: Consumer(
                                builder:
                                    (context, ref, child) => switch (ref.watch(
                                      userDatabaseProvider,
                                    )) {
                                      InitialState() => const Text(
                                        'No gender',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      LoadingState() =>
                                        CupertinoActivityIndicator(),
                                      LoadedSuccessfuly(user: var user) => Text(
                                        user.gender.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      ErrorState(error: var error) => Text(
                                        'No gender found',
                                      ),
                                      EmptyState() => Text('No gender found'),
                                    },
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: ListTile(
                              leading: const Text(
                                'Age:',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              title: Consumer(
                                builder:
                                    (context, ref, child) => switch (ref.watch(
                                      userDatabaseProvider,
                                    )) {
                                      InitialState() => const Text(
                                        'No age',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      LoadingState() =>
                                        CupertinoActivityIndicator(),
                                      LoadedSuccessfuly(user: var user) => Text(
                                        user.age.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      ErrorState(error: var error) => Text(
                                        'No age found',
                                      ),
                                      EmptyState() => Text('No age found'),
                                    },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
