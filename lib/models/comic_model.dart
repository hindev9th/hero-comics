import 'package:test_app/models/chapter_model.dart';

class ComicModel {
  String? image;
  ChapterModel? chapter;
  String? anotherName;
  String? view;
  String? name;
  String? description;
  String? id;
  String? categories;
  String? follow;
  String? url;
  String? status;
  String? apiChapter;

  ComicModel(
      {this.image,
      this.chapter,
      this.anotherName,
      this.view,
      this.name,
      this.description,
      this.id,
      this.categories,
      this.follow,
      this.status,
      this.url,
      this.apiChapter});

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'image': String image,
      'another_name': String anotherName,
      'view': String view,
      'name': String name,
      'description': String description,
      'id': String id,
      'categories': String categories,
      'follow': String follow,
      'url': String url,
      'api_chapter': String apiChapter,
      } =>
          ComicModel(
            image: image,
            chapter: ChapterModel.fromJson(json['chapter']),
            anotherName: anotherName,
            view: view,
            name: name,
            description: description,
            id: id,
            categories: categories,
            follow: follow,
            url: url,
            apiChapter: apiChapter,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
