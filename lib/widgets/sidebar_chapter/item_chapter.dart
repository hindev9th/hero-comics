import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/chapter_model.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/pages/read_page.dart';

class ItemChapter extends StatefulWidget {
  final ChapterModel chapterModel;
  final ComicModel comicModel;
  final bool isSelected;
  final Function? setChapterCurrent;
  const ItemChapter(
      {super.key,
      required this.chapterModel,
      required this.isSelected,
      required this.comicModel,
      this.setChapterCurrent});

  @override
  State<ItemChapter> createState() => _ItemChapterState();
}

class _ItemChapterState extends State<ItemChapter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.setChapterCurrent != null) {
          widget.setChapterCurrent!(widget.chapterModel);
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ReadPage(
                      chapterModel: widget.chapterModel,
                      comicModel: widget.comicModel,
                    )),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
            color: widget.isSelected ? clPrimary : Colors.white,
            border: Border.all(width: 1, color: clPrimary),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.chapterModel.name ?? "",
                style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Text(
              widget.chapterModel.time ?? "",
              style: TextStyle(
                  color: widget.isSelected ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
