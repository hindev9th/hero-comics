import 'package:flutter/material.dart';
import 'package:test_app/models/item_comic_model.dart';

class ItemComic extends StatefulWidget {
  final ItemComicModel itemComicModel;

  const ItemComic({super.key, required this.itemComicModel});

  @override
  State<ItemComic> createState() => _ItemComicState();
}

class _ItemComicState extends State<ItemComic> {
  @override
  Widget build(BuildContext context) {
    final itemComicModel = widget.itemComicModel;
    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              itemComicModel.image,
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Text(
                itemComicModel.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
