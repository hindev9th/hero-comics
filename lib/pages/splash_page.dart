import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Future<void> loadBaseUrl() async {
  //   final res = await HttpApi().get('/configs/crawl-url');
  //   Constants.BASE_CRAWL_URL = res['data'];
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     Navigator.pushReplacement(
  //         context,
  //         CupertinoPageRoute(
  //           builder: (context) => const BottomNavigation(),
  //         ));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // loadBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  "https://goctruyentranh.pro/image/1oWBRizB4QLAFspSHyooo7WUSody30Nm9?code=gtt",
                  headers: {
                    "referer": "https://goctruyentranhvui2.com",
                  },
                ),
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.modulate),
                opacity: 1,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
