import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/controllers/theme_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({super.key});

  static const pageName = '/theme_button';

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton>
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final String darkValue = 'Dark';

  final String lightValue = 'Light';

  final String systemValue = 'System';

  @override
  Widget build(BuildContext context) {
    print('THEME BUILD CALLED');
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            'Theme',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(0),
        child: Center(
          child: SlideTransition(
            position: scale,
            child: CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: Icon(Icons.light_mode),
                  title: const Text('Light'),
                  trailing: Consumer(
                    builder:
                        (context, ref, child) => Radio(
                          value: lightValue,
                          activeColor: Colors.orange,
                          groupValue: ref.watch(
                            themeByRadioProvider.select(
                              (value) => value.groupValue,
                            ),
                          ),
                          onChanged: (value) {
                            ref
                                .read(themeByRadioProvider.notifier)
                                .onChanged(value!);
                          },
                        ),
                  ),
                ),

                CupertinoListTile(
                  leading: Icon(Icons.dark_mode),
                  title: const Text('Dark'),
                  trailing: Consumer(
                    builder:
                        (context, ref, child) => Radio(
                          activeColor: Colors.orange,
                          value: darkValue,
                          // ignore: deprecated_member_use
                          groupValue: ref.watch(
                            themeByRadioProvider.select(
                              (value) => value.groupValue,
                            ),
                          ),

                          onChanged: (value) {
                            ref
                                .read(themeByRadioProvider.notifier)
                                .onChanged(value!);
                          },
                        ),
                  ),
                ),

                CupertinoListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('System'),
                  trailing: Consumer(
                    builder:
                        (context, ref, child) => Radio(
                          value: systemValue,
                          activeColor: Colors.orange,
                          groupValue: ref.watch(
                            themeByRadioProvider.select(
                              (value) => value.groupValue,
                            ),
                          ),
                          onChanged: (value) {
                            ref
                                .read(themeByRadioProvider.notifier)
                                .onChanged(value!);
                          },
                        ),
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
