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
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },

        icon: const Icon(CupertinoIcons.back, color: Colors.white),
      ),
      expandedHeight: 150,
      flexibleSpace: GradientsBackgroundAppbarWidget(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Consumer(
                builder:
                    (context, searchWord, child) => TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128),
                      ),
                      controller: controller,
                      onChanged: (value) {
                        searchWord
                            .read(searchListProvider.notifier)
                            .onChanged(value);
                      },

                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                        hintText: 'Search',

                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 128, 128, 128),
                        ),
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
