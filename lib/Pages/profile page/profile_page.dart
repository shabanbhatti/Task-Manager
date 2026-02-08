import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager_project/Pages/profile%20page/controllers/profile_noti_switch_riverpod.dart';
import 'package:task_manager_project/Pages/theme%20page/theme_page.dart';
import 'package:task_manager_project/Pages/update%20user%20identity%20page/update_user_identity_page.dart';
import 'package:task_manager_project/Pages/user%20information%20page/user_info_page.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/services/database_service.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';
import 'package:task_manager_project/utils/dialog%20boxes/clear_dialog_box.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/view_or_set_img_model_bottom_sheet.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  static const pageName = '/user_detail';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> scale;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    scale = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset(0, 0),
    ).animate(controller);

    controller.forward();

    Future.microtask(() {
      ref.read(notiSwitcherProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Profile page build called');
    return Scaffold(
      appBar: AppBar(
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
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,

        child: SlideTransition(
          position: scale,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Consumer(
                    builder:
                        (context, ref, child) => Material(
                          borderRadius: BorderRadius.circular(500),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () {
                              viewOrSetImage(context);
                            },
                            onLongPress: () {
                              showCupertinoDialog(
                                barrierDismissible: true,

                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: Colors.transparent,

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
                                                backgroundColor: Colors.orange,
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
                                              child: switch (ref.watch(
                                                userDatabaseProvider,
                                              )) {
                                                InitialUserState() =>
                                                  Image.asset(loadingImgPath),
                                                LoadingUserState() =>
                                                  Image.asset(loadingImgPath),
                                                LoadedUserSuccessfuly(
                                                  user: var user,
                                                ) =>
                                                  (user.imgPath == null)
                                                      ? Image.asset(
                                                        cameraIconImgPath,
                                                      )
                                                      : Image.file(
                                                        File(user.imgPath!),
                                                        height: 300,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                ErrorUserState(
                                                  error: var error,
                                                ) =>
                                                  Image.asset(
                                                    cameraIconImgPath,
                                                  ),
                                                EmptyUserState() => Image.asset(
                                                  cameraIconImgPath,
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
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.transparent,

                                backgroundImage: switch (ref.watch(
                                  userDatabaseProvider,
                                )) {
                                  InitialUserState() => const AssetImage(
                                    cameraIconImgPath,
                                  ),
                                  LoadingUserState() => const AssetImage(
                                    loadingImgPath,
                                  ),
                                  LoadedUserSuccessfuly(user: var user) =>
                                    (user.imgPath == null)
                                        ? AssetImage(cameraIconImgPath)
                                        : FileImage(File(user.imgPath!)),
                                  ErrorUserState(error: var error) =>
                                    const AssetImage(cameraIconImgPath),
                                  EmptyUserState() => const AssetImage(
                                    cameraIconImgPath,
                                  ),
                                },
                                child:
                                    (ref.watch(userDatabaseProvider) ==
                                            InitialUserState())
                                        ? Icon(CupertinoIcons.camera)
                                        : (ref.watch(userDatabaseProvider) ==
                                            LoadingUserState())
                                        ? CupertinoActivityIndicator()
                                        : null,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 0),
                  child: Consumer(
                    builder:
                        (context, ref, child) => switch (ref.watch(
                          userDatabaseProvider,
                        )) {
                          InitialUserState() => const Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          LoadingUserState() => Skeletonizer(
                            child: const Text(
                              'Username is here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          LoadedUserSuccessfuly(user: var user) => Text(
                            user.userName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          ErrorUserState(error: var error) => Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          EmptyUserState() => Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        },
                  ),
                ),

                Consumer(
                  builder:
                      (context, ref, child) => switch (ref.watch(
                        userDatabaseProvider,
                      )) {
                        InitialUserState() => const Text(
                          'No Occupation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        LoadingUserState() => Skeletonizer(
                          child: const Text(
                            'Occupation is here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        LoadedUserSuccessfuly(user: var user) => Text(
                          ' ${user.occupation ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 130, 130, 130),
                          ),
                        ),
                        ErrorUserState(error: var error) => Text(
                          error,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        EmptyUserState() => Text(
                          'No Occupation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      },
                ),

                Column(
                  children: [
                    CupertinoListSection.insetGrouped(
                      children: [
                        CupertinoListTile(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(ThemeButton.pageName);
                          },

                          leading: Icon(Icons.light_mode),
                          title: const Text('Theme'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        ),
                        CupertinoListTile(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(UpdateButton.pageName);
                          },

                          leading: Icon(Icons.refresh),
                          title: const Text('Update identity'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        ),

                        CupertinoListTile(
                          onTap: () {
                            showClearCacheDialog(context, () async {
                              final db = Db();
                              await db.clearAllData();

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('All local data cleared'),
                                ),
                              );
                            });
                          },

                          leading: Icon(Icons.delete),
                          title: Text('Clear cache'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        ),
                      ],
                      backgroundColor: Colors.transparent,
                    ),

                    CupertinoListSection.insetGrouped(
                      backgroundColor: Colors.transparent,
                      children: [
                        CupertinoListTile(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(UserInfoPage.pageName);
                          },

                          leading: const Icon(Icons.person),
                          title: const Text('User information'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ),

                        CupertinoListTile(
                          leading: const Icon(Icons.notifications),
                          title: const Text('Notification'),
                          trailing: Consumer(
                            builder:
                                (context, ref, child) => CupertinoSwitch(
                                  activeTrackColor: Colors.green,
                                  value: ref.watch(notiSwitcherProvider),
                                  onChanged: (value) {
                                    ref
                                        .read(notiSwitcherProvider.notifier)
                                        .onChanged(value);
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
