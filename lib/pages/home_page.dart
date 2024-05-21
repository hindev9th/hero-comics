import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/common/http_api.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/responses/comic_response.dart';
import 'package:test_app/widgets/item_comic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ComicResponse> comicData;
  ScrollController scrollController = ScrollController();
  late ComicResponse comicResponse;
  late int page = 1;
  late bool isLoading = false;
  Future<ComicResponse> fetchAlbum() async {
    setState(() {
      isLoading = true;
    });
    final data = await HttpApi()
        .get('${dotenv.env['PUBLIC_URL_API']}/comics?page=$page');

    ComicResponse comicResponseTemp = ComicResponse.fromJson(data['data']);
    if (page > 1) {
      comicResponse.list!
          .addAll(comicResponseTemp.list as Iterable<ComicModel>);
      comicResponse.currentPage = comicResponseTemp.currentPage;
      comicResponse.currentSize = comicResponseTemp.currentSize;
      comicResponse.sizePage = comicResponseTemp.sizePage;
      comicResponse.totalItem = comicResponseTemp.totalItem;
      comicResponse.totalPage = comicResponseTemp.totalPage;
    } else {
      comicResponse = ComicResponse.fromJson(data['data']);
    }
    setState(() {
      isLoading = false;
    });
    return comicResponse;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      if (!isLoading) {
        page = 1;
        comicData = fetchAlbum();
      }
    });
  }

  Future<void> loadMore() async {
    setState(() {
      if (!isLoading) {
        page += 1;
        comicData = fetchAlbum();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    comicData = fetchAlbum();
    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 2;
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/ic_app.png',
                      width: 40,
                    ),
                    const Text(
                      "eroComics", // Corrected app name
                      style: TextStyle(
                        fontSize: 22,
                        color: clPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: const Text(
                "Truyện mới",
                style: TextStyle(
                  color: clPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            FutureBuilder<ComicResponse>(
              future: comicData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        List.generate(snapshot.data!.list!.length, (index) {
                      return SizedBox(
                          width: itemWidth - 12,
                          child: ItemComic(
                              comicModel: snapshot.data!.list![index]));
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
                return Container();
              },
            ),
            if (isLoading)
              Center(
                heightFactor: 10,
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: clPrimary,
                  size: 50,
                ),
              )
          ],
        ),
      ),
    );
  }
}
