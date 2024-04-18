import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/config/string.dart';
import 'package:test_app/responses/chapter_response.dart';
import 'package:test_app/widgets/sidebar_chapter/item_chapter.dart';
import 'package:http/http.dart' as http;


class SidebarChapter extends StatefulWidget {
  final String apiChapter;
  const SidebarChapter({super.key, required this.apiChapter});

  @override
  State<SidebarChapter> createState() => _SidebarChapterState();
}

class _SidebarChapterState extends State<SidebarChapter> {
  late Future<ChapterResponse> chapterData;

  Future<ChapterResponse> fetchAlbum() async {
    final response = await http
        .get(Uri.parse(widget.apiChapter));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ChapterResponse.fromJson(data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    chapterData = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<ChapterResponse>(
          future: chapterData,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.chapters!.length,
                itemBuilder: (context, index) {
                  return ItemChapter(
                    chapterModel: snapshot.data!.chapters![index],
                    isSelected: false,
                  );
                },
              );
            }else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
