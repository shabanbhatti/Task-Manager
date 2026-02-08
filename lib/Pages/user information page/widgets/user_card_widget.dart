import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/Models/user_model.dart';
import 'package:task_manager_project/Pages/profile%20page/controllers/profile_img_riverpod.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/utils/constant_img_paths.dart';

class UserCard extends ConsumerStatefulWidget {
  final User? user;
  const UserCard({super.key, this.user});

  @override
  ConsumerState<UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<UserCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _widthAnim;
  // late final Animation<double> _heightAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _widthAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,

        curve: const Interval(0.0, 0.5, curve: Curves.easeInBack),
      ),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInBack),
      ),
    );

    _slideAnim = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: ScaleTransition(
        scale: _widthAnim,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          child: FadeTransition(opacity: _fadeAnim, child: _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.white.withAlpha(100),
          backgroundImage:
              widget.user?.imgPath == null
                  ? const AssetImage(cameraIconImgPath)
                  : FileImage(File(widget.user!.imgPath!)) as ImageProvider,
        ),

        TextButton(
          onPressed: () {
            ref
                .read(circleAvatarImgProvider.notifier)
                .takeImage(ImageSource.gallery)
                .then(
                  (_) => ref.read(userDatabaseProvider.notifier).fetchUser(),
                );
          },
          child: const Text(
            'Change your profile picture',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 87, 151),
            ),
          ),
        ),

        _infoTile('Name', widget.user?.userName),
        _infoTile('Nickname', widget.user?.nickName),
        _infoTile('Occupation', widget.user?.occupation),
        _infoTile('Gender', widget.user?.gender),
        _infoTile('Age', widget.user?.age?.toString()),
      ],
    );
  }

  Widget _infoTile(String label, String? value) {
    return ListTile(
      leading: Text(
        '$label:',
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      title: Text(
        value ?? 'Not set',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
