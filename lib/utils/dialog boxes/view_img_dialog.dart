import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';

void viewImgDialog(BuildContext context) {
  showCupertinoDialog(
    barrierDismissible: true,

    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          shape: CircleBorder(),

          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              InteractiveViewer(
                maxScale: 10,
                minScale: 0.1,
                child: Consumer(
                  builder: (context, ref, _) {
                    var x = ref.watch(userDatabaseProvider);
                    if (x is LoadedUserSuccessfuly) {
                      if ((x.user.imgPath == null)) {
                        return Image.asset(
                          cameraIconImgPath,
                          height: 200,
                          fit: BoxFit.fitHeight,
                        );
                      } else {
                        return Image.file(
                          File(x.user.imgPath ?? ''),
                          height: 200,
                          fit: BoxFit.fitHeight,
                        );
                      }
                    } else {
                      return Image.asset(
                        cameraIconImgPath,
                        height: 200,
                        fit: BoxFit.fitHeight,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
  );
}
