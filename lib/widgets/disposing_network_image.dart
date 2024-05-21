import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DisposingNetworkImage extends StatefulWidget {
  final String image;
  const DisposingNetworkImage({super.key, required this.image});

  @override
  State<DisposingNetworkImage> createState() => _DisposingNetworkImageState();
}

class _DisposingNetworkImageState extends State<DisposingNetworkImage> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: widget.image,
        height: 300,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) => SizedBox(
            height: 300,
            width: double.infinity,
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white, size: 30),
            )),
        errorWidget: (context, url, error) => const SizedBox(
            height: 300,
            width: double.infinity,
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 50,
            )));
  }
}
