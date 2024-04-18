import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/config/colors.dart';
import 'package:test_app/config/string.dart';
import 'package:test_app/models/comic_model.dart';
import 'package:test_app/pages/detail_page.dart';

class ItemComic extends StatefulWidget {
  final ComicModel comicModel;

  const ItemComic({super.key, required this.comicModel});

  @override
  State<ItemComic> createState() => _ItemComicState();
}

class _ItemComicState extends State<ItemComic> {
  @override
  Widget build(BuildContext context) {
    final comicModel = widget.comicModel;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DetailPage(
                    comicModel: comicModel,
                  )),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              comicModel.image ?? "",
              height: 300,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            height: 40,
            child: Text(
              comicModel.name ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.2, 0.1),
                    blurRadius: 20.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Text(
              comicModel.chapter!.name ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.2, 0.1),
                    blurRadius: 20.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
