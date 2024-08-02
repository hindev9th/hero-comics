import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/common/https/get_list_chapters.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/chapter_model.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/models/response/response_detail_comic.dart';
import 'package:test_app/pages/read_page.dart';
import 'package:test_app/sqflite/sqflite.dart';
import 'package:test_app/widgets/sidebar_chapter/sidebar_chapter.dart';

class DetailPage extends StatefulWidget {
  final Comic comicModel;

  const DetailPage({super.key, required this.comicModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<ResponseDetail> chapterData;
  final DbHelper dbHelper = DbHelper();

  bool loading = false;
  late Chapter chapterModelFirst;
  late Chapter chapterModelReding;
  late bool readed = false;
  late Map<String, dynamic> history;

  Future<ResponseDetail> fetchAlbum() async {
    Comic comicModel = widget.comicModel;
    setState(() {
      loading = true;
    });
    final response = await getListChapter(comicModel.id);
    // _loadChapterReading(
    //     response?.chapters ?? [], history["chapter_id"]);
    chapterModelFirst = response!.result!.chapters!.last;
    // if (history['comic_id'] != '0') {
    //   setState(() {
    //     readed = true;
    //   });
    // }
    setState(() {
      loading = false;
    });
    return response;
  }

  @override
  void initState() {
    super.initState();
    chapterData = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clPrimary,
      endDrawer: SidebarChapter(
        chapterData: chapterData,
        comicModel: widget.comicModel,
        chapterCurrentId: readed ? history['chapter_id'] : "0",
      ),
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        offset: const Offset(0, 20),
                        blurRadius: 20,
                      )
                    ]),
                child: IconButton(
                    onPressed: () {
                      print("tap heart");
                    },
                    icon: const Icon(Icons.favorite))),
            GestureDetector(
              onTap: () {
                if (!loading) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ReadPage(
                              chapter: readed
                                  ? chapterModelReding
                                  : chapterModelFirst,
                              comicModel: widget.comicModel,
                            )),
                  );
                }
              },
              child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          offset: const Offset(0, 20),
                          blurRadius: 20,
                        )
                      ]),
                  child: loading
                      ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: clPrimary,
                            size: 30,
                          ),
                        )
                      : Text(
                          readed ? "Đọc tiếp" : "Đọc ngay",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: clPrimary,
            expandedHeight: 450,
            elevation: 0,
            pinned: true,
            titleSpacing: 0,
            stretch: true,
            leadingWidth: 80,
            collapsedHeight: 90,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.comicModel.photo,
                fit: BoxFit.fitWidth,
                headers: {
                  "referer": dotenv.env['PUBLIC_URL_API']!,
                  "priority": "u=1, i"
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                    color: clPrimary,
                    size: 50,
                  ));
                },
              ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: clPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: clPrimary,
                      blurRadius: 0.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(bottom: 80, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Chapter ${widget.comicModel.chapterLatest[0]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Text(" | ", style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 16,
                            color: clFocus,
                          ),
                          Container(
                            width: 2,
                          ),
                          Text(
                            widget.comicModel.viewCount,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Text(" | ", style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 16,
                            color: clFocus,
                          ),
                          Container(
                            width: 2,
                          ),
                          Text(
                            widget.comicModel.followerCount,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 25,
                  ),
                  Text(
                    widget.comicModel.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    widget.comicModel.otherName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    height: 25,
                  ),
                  Text(
                    widget.comicModel.description,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _loadChapterReading(List<Chapter> chapters, String historyId) {
    for (var chapter in chapters) {
      if (historyId == "0") {
        break;
      }
      if (chapter.id == historyId) {
        setState(() {
          chapterModelReding = chapter;
        });
        break;
      }
    }
  }
}
