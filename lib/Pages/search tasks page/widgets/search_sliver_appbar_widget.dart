import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_project/Pages/search%20tasks%20page/controllers/search_controller.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class SearchSliverAppbarWidget extends StatelessWidget {
  const SearchSliverAppbarWidget({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: SizedBox(),
      expandedHeight: 130,
      snap: true,
      floating: true,
      primary: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: GradientsBackgroundAppbarWidget(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.xmark_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Consumer(
                builder:
                    (context, searchWord, child) => CupertinoSearchTextField(
                      controller: controller,
                      placeholderStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      style: const TextStyle(color: Colors.grey),

                      cursorColor: Colors.grey,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      onChanged: (value) {
                        searchWord
                            .read(searchListProvider.notifier)
                            .onChanged(value);
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
