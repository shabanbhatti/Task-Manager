import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/View%20task%20page/view_task_page.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/controllers/search_controller.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/widgets/search_sliver_appbar_widget.dart';
import 'package:task_manager_project/Pages/update%20task%20page/update_task_page.dart';
import 'package:task_manager_project/controllers/task_db_controller.dart';
import 'package:task_manager_project/utils/dialog%20boxes/delete_dialog.dart';
import 'package:task_manager_project/utils/show%20model%20bottom%20sheets/options_model_bottom_sheet.dart';
import 'package:task_manager_project/widgets/list%20tile%20widget/(home%20&%20search)list_tile_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  static const String pageName = '/searchPage';
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(tasksProvider.notifier).fetchTasks();
      ref.read(searchListProvider.notifier).searchListMethod();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SearchSliverAppbarWidget(controller: controller),

          Consumer(
            builder: (context, myRef, child) {
              var searchList = myRef.watch(searchListProvider);
              if (searchList.isNotEmpty) {
                return SliverList.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    bool isLast = index == searchList.length - 1;
                    return InkWell(
                      onLongPress: () {
                        showOptionsBottomSheet(
                          context,
                          () {
                            Navigator.of(context)
                                .pushNamed(
                                  ViewTaskPage.pageName,
                                  arguments:
                                      {
                                            'tasks': searchList[index],
                                            'isFromComplete': false,
                                          }
                                          as Map<String, dynamic>,
                                )
                                .then((value) {
                                  Navigator.pop(context);
                                });
                          },
                          () {
                            showDeleteDialog(context, () {
                              ref
                                  .read(tasksProvider.notifier)
                                  .deleteTask(searchList[index])
                                  .then((value) {
                                    ref
                                        .read(searchListProvider.notifier)
                                        .remove(index);
                                  });
                            }).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          () {
                            Navigator.pushNamed(
                              context,
                              UpdateTask.pageName,
                              arguments: searchList[index],
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ViewTaskPage.pageName,
                          arguments:
                              {
                                    'tasks': searchList[index],
                                    'isFromComplete': false,
                                  }
                                  as Map<String, dynamic>,
                        );
                      },
                      child: HomeAndSearchListTile(
                        isLast: isLast,
                        tasks: searchList[index],
                      ),
                    );
                  },
                );
              } else {
                return SliverFillRemaining(
                  hasScrollBody: true,

                  fillOverscroll: false,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 5),
                        const Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.assignment,
                            color: Colors.deepOrange,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            'Result for "${controller.text.trim()}"',
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
