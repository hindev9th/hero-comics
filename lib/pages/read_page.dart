import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/common/http_api.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/chapter_model.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/responses/chapter_response.dart';
import 'package:test_app/sqflite/sqflite.dart';
import 'package:test_app/widgets/sidebar_chapter/sidebar_chapter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReadPage extends StatefulWidget {
  final ChapterModel chapterModel;
  final ComicModel comicModel;

  const ReadPage(
      {super.key, required this.chapterModel, required this.comicModel});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  late ChapterModel chapterCurrent;
  late ChapterModel chapterNext;
  late ChapterModel chapterBefore;
  final DbHelper dbHelper = DbHelper();
  late final WebViewController _controller;
  bool isScrollDown = false;
  late List<ChapterModel> chapterList;
  bool isChapterNext = false;
  bool isChapterBefore = false;

  bool loading = true;
  String css =
      "#header,.notify_block,.top,.reading-control,#back-to-top,.mrt5.mrb5.text-center.col-sm-6,.top.bottom,.footer,.reading > .container{display: none !important;}";

  late Future<ChapterResponse> chapterData;
  bool loadingChapter = false;

  Future<ChapterResponse> fetchAlbum() async {
    ComicModel comicModel = widget.comicModel;
    setState(() {
      loadingChapter = true;
    });
    final data = await HttpApi()
        .get('${dotenv.env['PUBLIC_URL_API']}/chapters?key=${comicModel.url}');

    await dbHelper.upsertHistory(
        widget.comicModel.id ?? "0",
        widget.chapterModel.id ?? "0",
        widget.chapterModel.name ?? "",
        widget.chapterModel.url ?? "");

    ChapterResponse chapterResponse = ChapterResponse.fromJson(data);
    setState(() {
      chapterList = chapterResponse.chapters!;
      loadingChapter = false;
    });
    _loadChapterNext();

    return chapterResponse;
  }

  @override
  void initState() {
    super.initState();
    chapterData = fetchAlbum();
    chapterCurrent = widget.chapterModel;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress > 20) {
              setState(() {
                _hideCss().then((value) => loading = false);
                _controller.runJavaScript('''window.onscroll = function(e) {
                  // print "false" if direction is down and "true" if up
                  Toaster.postMessage(this.oldScroll > this.scrollY);
                  this.oldScroll = this.scrollY;
                }''');
              });
            }
          },
          onPageStarted: (String url) {
            _controller.clearCache();
            _controller.clearLocalStorage();
            setState(() {
              loading = true;
            });
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (request) {
            if (!request.url.startsWith('https://www')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          setState(() {
            isScrollDown = message.message.toLowerCase() == 'false';
          });
        },
      )
      ..loadRequest(Uri.parse(widget.chapterModel.url ?? ""));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: Text(
          chapterCurrent.name ?? "",
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
          : WebViewWidget(controller: _controller),
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

  Future<void> _hideCss() {
    return _controller.runJavaScript(
      "var style = document.createElement('style'); style.innerHTML = '$css'; document.head.appendChild(style);",
    );
  }

  void _setChapterCurrent(ChapterModel chapterModel) {
    setState(() {
      loading = true;
      chapterCurrent = chapterModel;
      dbHelper.upsertHistory(
          widget.comicModel.id ?? "0",
          chapterModel.id ?? "0",
          chapterModel.name ?? "",
          chapterModel.url ?? "");
    });
    _controller.loadRequest(Uri.parse(chapterModel.url ?? ""));

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
