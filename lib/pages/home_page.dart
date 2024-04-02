import 'package:flutter/material.dart';
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

    final double itemWidth = size.width / 2;
    return Column(
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(itemComicsList.length, (index) {
            return SizedBox(
                width: itemWidth - 12,
                child: ItemComic(comicModel: itemComicsList[index]));
          }),
        ),
      ],
    );
  }
}
