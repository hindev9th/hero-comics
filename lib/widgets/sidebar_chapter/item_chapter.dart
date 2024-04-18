import 'package:flutter/material.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/chapter_model.dart';

class ItemChapter extends StatelessWidget {
  final ChapterModel chapterModel;
  final bool isSelected;
  const ItemChapter(
      {super.key, required this.chapterModel, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tap chapter" + (chapterModel.name ?? ""));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
            color: isSelected ? clPrimary : Colors.white,
            border: Border.all(width: 1, color: clPrimary),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              chapterModel.name ?? "",
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
            Text(
              chapterModel.time ?? "",
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
