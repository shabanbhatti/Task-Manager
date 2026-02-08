import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/user%20information%20page/widgets/user_card_widget.dart';
import 'package:task_manager_project/controllers/user_db_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});
  static const pageName = 'user_info';

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = Tween(begin: 0.9, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('INFO PAGE CALLED');
    final userState = ref.watch(userDatabaseProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(15),
        child: ScaleTransition(
          scale: _scale,
          child: Center(child: _buildBody(userState)),
        ),
      ),
    );
  }

  Widget _buildBody(UserState state) {
    if (state is LoadingUserState) {
      return const CupertinoActivityIndicator(radius: 18);
    }

    if (state is LoadedUserSuccessfuly) {
      return UserCard(user: state.user);
    }

    return UserCard(user: null);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
      ),
      flexibleSpace: const FlexibleSpaceBar(
        background: GradientsBackgroundAppbarWidget(),
        centerTitle: true,
        title: Text(
          'User information',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
