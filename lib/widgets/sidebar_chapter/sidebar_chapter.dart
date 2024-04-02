import 'package:flutter/material.dart';
import 'package:test_app/config/string.dart';
import 'package:test_app/widgets/sidebar_chapter/item_chapter.dart';

class SidebarChapter extends StatelessWidget {
  const SidebarChapter({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: itemChapterList.length,
          itemBuilder: (context, index) {
            return ItemChapter(
              chapterModel: itemChapterList[index],
              isSelected: false,
            );
          },
        ),
      ),
    );
  }
}
