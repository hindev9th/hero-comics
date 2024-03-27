import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/config/string.dart';
import 'package:test_app/widgets/item_comic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 130) / 2;
    final double itemWidth = size.width / 2;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        children: [
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
                    "eroComics",
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
                  ))
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: const Text(
              "Truyện mới",
              style: TextStyle(
                  color: clPrimary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: (itemWidth / itemHeight),
                  scrollDirection: Axis.vertical,
                  children: List.generate(itemComicsList.length, (index) {
                    return ItemComic(itemComicModel: itemComicsList[index]);
                  })),
            ),
          ),
        ],
      ),
    ));
  }
}
