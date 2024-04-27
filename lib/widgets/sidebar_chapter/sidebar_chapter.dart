import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/responses/chapter_response.dart';
import 'package:test_app/widgets/sidebar_chapter/item_chapter.dart';

class SidebarChapter extends StatefulWidget {
  final Future<ChapterResponse> chapterData;
  final ComicModel comicModel;
  final String? chapterCurrentId;
  final Function? setChapterCurrent;
  const SidebarChapter(
      {super.key,
      required this.chapterData,
      required this.comicModel,
      this.chapterCurrentId,
      this.setChapterCurrent});

  @override
  State<SidebarChapter> createState() => _SidebarChapterState();
}

class _SidebarChapterState extends State<SidebarChapter> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<ChapterResponse>(
          future: widget.chapterData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.chapters!.length,
                itemBuilder: (context, index) {
                  return ItemChapter(
                    chapterModel: snapshot.data!.chapters![index],
                    comicModel: widget.comicModel,
                    setChapterCurrent: widget.setChapterCurrent,
                    isSelected: widget.chapterCurrentId ==
                        snapshot.data!.chapters![index].id,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: clPrimary,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }
}
