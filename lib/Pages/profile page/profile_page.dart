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

class UserDetailPage extends ConsumerStatefulWidget {
  const UserDetailPage({super.key});

  static const pageName = '/user_detail';

  @override
  ConsumerState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage>
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
    print('User detail build called');
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
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        minimum: EdgeInsets.all(10),
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
                                                InitialState() => Image.asset(
                                                  loadingImgPath,
                                                ),
                                                LoadingState() => Image.asset(
                                                  loadingImgPath,
                                                ),
                                                LoadedSuccessfuly(
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
                                                ErrorState(error: var error) =>
                                                  Image.asset(
                                                    cameraIconImgPath,
                                                  ),
                                                EmptyState() => Image.asset(
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
                                  InitialState() => const AssetImage(
                                    cameraIconImgPath,
                                  ),
                                  LoadingState() => const AssetImage(
                                    loadingImgPath,
                                  ),
                                  LoadedSuccessfuly(user: var user) =>
                                    (user.imgPath == null)
                                        ? AssetImage(cameraIconImgPath)
                                        : FileImage(File(user.imgPath!)),
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
                                        : (ref.watch(userDatabaseProvider) ==
                                            LoadingState())
                                        ? CupertinoActivityIndicator()
                                        : null,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Consumer(
                    builder:
                        (context, ref, child) => switch (ref.watch(
                          userDatabaseProvider,
                        )) {
                          InitialState() => const Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          LoadingState() => Skeletonizer(
                            child: const Text(
                              'Username is here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          LoadedSuccessfuly(user: var user) => Text(
                            user.userName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          ErrorState(error: var error) => Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          EmptyState() => Text(
                            'No Username',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        },
                  ),
                ),

                const Divider(),
                SafeArea(
                  minimum: EdgeInsets.only(right: 10, left: 10, top: 30),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(ThemeButton.pageName);
                        },
                        tileColor: Colors.grey.withAlpha(100),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        leading: Icon(Icons.light_mode),
                        title: const Text('Theme'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),

                      ListTile(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(UpdateButton.pageName);
                        },
                        tileColor: Colors.grey.withAlpha(100),

                        leading: Icon(Icons.refresh),
                        title: const Text('Update identity'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),

                      ListTile(
                        onTap: () {
                          showClearCacheDialog(context, () async {
                            final db = Db();
                            await db.clearAllData();

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('All local data cleared')),
                            );
                          });
                        },
                        tileColor: Colors.grey.withAlpha(100),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        leading: Icon(Icons.delete),
                        title: Text('Clear cache'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(UserInfoPage.pageName);
                          },
                          tileColor: Colors.grey.withAlpha(100),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          leading: const Icon(Icons.person),
                          title: const Text('User information'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        ),
                      ),

                      ListTile(
                        tileColor: Colors.grey.withAlpha(100),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notification'),
                        trailing: Consumer(
                          builder:
                              (context, ref, child) => Switch(
                                trackOutlineColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor,
                                ),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey.withAlpha(150),
                                activeThumbColor: Colors.white,
                                activeTrackColor: Colors.orange,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
