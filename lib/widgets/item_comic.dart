import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              comicModel.image,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 10,
            child: Text(
              comicModel.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              comicModel.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
