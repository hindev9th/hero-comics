import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/common/https/get_list_comics.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/widgets/item_comic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Comic>> comicData;
  ScrollController scrollController = ScrollController();
  late List<Comic> listComics;
  late int page = 0;
  late bool isLoading = false;
  Future<List<Comic>> fetchAlbum() async {
    setState(() {
      isLoading = true;
    });
    final data = await getListComics(page);

    if (page > 1) {
      listComics.addAll(data?.result?.data ?? []);
    } else {
      listComics = data?.result?.data  ?? [];
    }
    setState(() {
      isLoading = false;
    });
    return listComics;
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
            FutureBuilder<List<Comic>>(
              future: comicData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        List.generate(snapshot.data!.length, (index) {
                      return SizedBox(
                          width: itemWidth - 12,
                          child: ItemComic(
                              comicModel: snapshot.data![index]));
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
