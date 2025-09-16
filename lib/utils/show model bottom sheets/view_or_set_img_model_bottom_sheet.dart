import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/Pages/profile%20page/controllers/profile_img_riverpod.dart';
import 'package:task_manager_project/services/database_service.dart';
import 'package:task_manager_project/utils/dialog%20boxes/delete_dialog_box.dart';

void viewOrSetImage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder:
                (context, ref, child) => switch (ref.watch(
                  userDatabaseProvider,
                )) {
                  InitialState() => SizedBox(),
                  LoadingState() => SizedBox(),
                  LoadedSuccessfuly(user: var user) =>
                    (user.imgPath != null && user.imgPath!.isNotEmpty)
                        ? ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('View Image'),
                          onTap: () {
                            Navigator.pop(context);
                            showCupertinoDialog(
                              barrierDismissible: true,

                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor: Colors.transparent,

                                    content: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close),
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
                                                  'assets/images/loading.png',
                                                ),
                                                LoadingState() => Image.asset(
                                                  'assets/images/loading.png',
                                                ),
                                                LoadedSuccessfuly(
                                                  user: var user,
                                                ) =>
                                                  (user.imgPath!.isEmpty ||
                                                          user.imgPath == null)
                                                      ? Image.asset(
                                                        'assets/images/camera.png',
                                                      )
                                                      : Image.file(
                                                        File(user.imgPath!),
                                                        height: 300,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                ErrorState(error: var error) =>
                                                  Image.asset(
                                                    'assets/images/camera.png',
                                                  ),
                                                EmptyState() => Image.asset(
                                                  'assets/images/camera.png',
                                                ),
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            );
                          },
                        )
                        : SizedBox(),
                  ErrorState(error: var error) => SizedBox(),

                  EmptyState() => Text(''),
                },
          ),
          Consumer(
            builder:
                (context, ref, child) => ListTile(
                  leading: const Icon(Icons.add_a_photo),
                  title: const Text('Add new profile image'),
                  onTap: () {
                    ref
                        .read(circleAvatarImgProvider.notifier)
                        .takeImage(ImageSource.gallery)
                        .then((value) {
                          ref.read(userDatabaseProvider.notifier).fetchUser();
                          Navigator.pop(context);
                        });
                  },
                ),
          ),

          Consumer(
            builder:
                (context, ref, child) => switch (ref.watch(
                  userDatabaseProvider,
                )) {
                  InitialState() => SizedBox(),
                  LoadingState() => SizedBox(),
                  LoadedSuccessfuly(user: var user) =>
                    (user.imgPath != null && user.imgPath!.isNotEmpty)
                        ? ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text(
                            'Delete image',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            
                            final Db db = Db();

                            deleteDialog(context, () async {
                              var user = await db.fetchUser();

                              ref
                                  .read(userDatabaseProvider.notifier)
                                  .updateUser(user.copyWith(imgPath: ''))
                                  .then((value) {
                                    ref
                                        .read(userDatabaseProvider.notifier)
                                        .fetchUser();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                            });
                          },
                        )
                        : SizedBox(),
                  ErrorState(error: var error) => SizedBox(),
                  EmptyState() => SizedBox(),
                },
          ),
        ],
      );
    },
  );
}
