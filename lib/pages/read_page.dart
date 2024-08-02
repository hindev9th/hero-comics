import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/common/https/get_list_chapters.dart';
import 'package:test_app/common/https/get_list_images.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/chapter_model.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/models/response/response_detail_comic.dart';
import 'package:test_app/models/response/response_page.dart';
import 'package:test_app/sqflite/sqflite.dart';
import 'package:test_app/widgets/image/list_images.dart';
import 'package:test_app/widgets/sidebar_chapter/sidebar_chapter.dart';

class ReadPage extends StatefulWidget {
  final Chapter chapter;
  final Comic comicModel;

  const ReadPage(
      {super.key, required this.chapter, required this.comicModel});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late Chapter chapterCurrent;
  late Chapter chapterNext;
  late Chapter chapterBefore;
  final DbHelper dbHelper = DbHelper();
  bool isScrollDown = false;
  late List<Chapter> chapterList;
  bool isChapterNext = false;
  bool isChapterBefore = false;

  bool loading = true;

  late Future<ResponseDetail?> chapterData;
  late Future<ResponsePage?> pageData;
  bool loadingChapter = false;

  Future<ResponsePage?> fetchAlbum(String numberChapter) async {
    Comic comicModel = widget.comicModel;
    setState(() {
      loadingChapter = true;
    });
    final data = await getImages(comicModel.id, numberChapter, comicModel.nameEn);

    // await dbHelper.upsertHistory(
    //     widget.comicModel.id,
    //     widget.chapter.id ?? "0",
    //     widget.chapter.name ?? "","");

    setState(() {
      loading = false;
      loadingChapter = false;
    });
    // _loadChapterNext();

    return data;
  }

  Future<ResponseDetail?> fetchDetail() async {
    Comic comicModel = widget.comicModel;
    setState(() {
      loadingChapter = true;
    });
    final data = await getListChapter(comicModel.id);
    // await dbHelper.upsertHistory(
    //     widget.comicModel.id,
    //     widget.chapter.id ?? "0",
    //     widget.chapter.name ?? "","");

    setState(() {
      chapterList = data!.result!.chapters ?? [];
      loadingChapter = false;
    });
    _loadChapterNext();

    return data;
  }

  @override
  void initState() {
    super.initState();
    pageData = fetchAlbum(widget.chapter.numberChapter ?? "1");
    chapterData = fetchDetail();
    chapterCurrent = widget.chapter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: Text(
          "Chapter ${chapterCurrent.numberChapter}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.2, 0.1),
                blurRadius: 20.0,
                color: Colors.white,
              ),
            ],
          ),
          maxLines: 1,
        )),
        leadingWidth: 80,
        leading: Container(
          margin: const EdgeInsets.only(
            left: 24,
          ),
          decoration: BoxDecoration(
              color: clFocus, borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          Container(
            width: 54,
            height: 54,
            margin: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
                color: clFocus, borderRadius: BorderRadius.circular(100)),
            child: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(
                  Icons.segment_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              );
            }),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      endDrawer: SidebarChapter(
        chapterData: chapterData,
        comicModel: widget.comicModel,
        chapterCurrentId: chapterCurrent.id,
        setChapterCurrent: _setChapterCurrent,
      ),
      body: loading
          ? Center(
              heightFactor: 15,
              child: LoadingAnimationWidget.fourRotatingDots(
                color: clPrimary,
                size: 50,
              ),
            )
          : ListImages(pageImages: pageData,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.3,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isScrollDown
              ? Matrix4.translationValues(0, 80, 0)
              : Matrix4.translationValues(0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
                color: clPrimary, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: clFocus,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  secondChild: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: clFocus,
                        borderRadius: BorderRadius.circular(30)),
                    child: (isChapterBefore)
                        ? IconButton(
                            onPressed: () {
                              if (!loadingChapter) {
                                _setChapterCurrent(chapterBefore);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ))
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.block,
                              color: Colors.black,
                            )),
                  ),
                  crossFadeState: loadingChapter
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: clFocus,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  secondChild: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: clFocus,
                        borderRadius: BorderRadius.circular(30)),
                    child: (isChapterNext)
                        ? IconButton(
                            onPressed: () {
                              if (!loadingChapter) {
                                _setChapterCurrent(chapterNext);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ))
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.block,
                              color: Colors.black,
                            )),
                  ),
                  crossFadeState: loadingChapter
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _setChapterCurrent(Chapter chapter) {
    setState(() {
      loading = true;
      chapterCurrent = chapter;
      pageData = fetchAlbum(chapter.numberChapter ?? "1");
    });

    _loadChapterNext();
  }

  void _loadChapterNext() {
    setState(() {
      loadingChapter = true;
    });
    for (var i = 0; i < chapterList.length; i++) {
      if (chapterList[i].id == chapterCurrent.id) {
        if ((i + 1) <= (chapterList.length - 1)) {
          setState(() {
            chapterBefore = chapterList[i + 1];
            isChapterBefore = true;
          });
        } else {
          setState(() {
            isChapterBefore = false;
          });
        }

        if ((i - 1) >= 0) {
          setState(() {
            chapterNext = chapterList[i - 1];
            isChapterNext = true;
          });
        } else {
          setState(() {
            isChapterNext = false;
          });
        }
        setState(() {
          loadingChapter = false;
        });
        break;
      }
    }
  }
}
