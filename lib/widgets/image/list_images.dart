import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/models/response/response_page.dart';
import 'package:test_app/widgets/disposing_network_image.dart';

class ListImages extends StatefulWidget {
  final Future<ResponsePage?> pageImages;
  const ListImages({super.key, required this.pageImages});

  @override
  State<ListImages> createState() => _ListImagesState();
}

class _ListImagesState extends State<ListImages> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResponsePage?>(
      future: widget.pageImages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.result!.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(0),
                child: Image.network(
                  snapshot.data!.result!.data![index],
                  fit: BoxFit.contain,
                  headers: {
                    "referer": dotenv.env['PUBLIC_URL_API']!,
                    "priority": "u=1, i"
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return Container();
      },
    );
  }
}
