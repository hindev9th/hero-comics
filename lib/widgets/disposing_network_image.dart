import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/config/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DisposingNetworkImage extends StatefulWidget {
  final NetworkImage image;
  const DisposingNetworkImage({super.key, required this.image});

  @override
  State<DisposingNetworkImage> createState() => _DisposingNetworkImageState();
}

class _DisposingNetworkImageState extends State<DisposingNetworkImage> {
  bool isShow = false;

  @override
  void dispose() {
    imageCache.evict(widget.image);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.image.url),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1 && !isShow) {
            setState(() {
              isShow = true;
            });
          }
          // When the image becomes invisible
          else if (info.visibleFraction <= 0.1 && isShow) {
            setState(() {
              isShow = false;
            });
          }
        },
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(color: clPrimary),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          secondChild: Image(
            image: widget.image,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: clPrimary),
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                secondChild: Center(child: child),
                crossFadeState: loadingProgress != null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            },
          ),
          crossFadeState:
              !isShow ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ));
  }
}
