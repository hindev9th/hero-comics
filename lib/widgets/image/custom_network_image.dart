import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomNetworkImage extends StatefulWidget {
  final String imageUrl;
  const CustomNetworkImage({super.key, required this.imageUrl});

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  Map<String, String> headers = {"Referer": dotenv.env['PUBLIC_URL_API'] ?? ""};

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      httpHeaders: headers,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        height: 600,
        width: double.infinity,
        child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.white, size: 30),
        ),
      ),
      errorWidget: (context, url, error) => const SizedBox(
        height: 600,
        width: double.infinity,
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
