import 'package:test_app/models/chapter_model.dart';

class ComicModel {
  final String id,
      name,
      otherName,
      url,
      image,
      category,
      status,
      view,
      follow,
      description;
  late ChapterModel? chapterModel;
  ComicModel(
      {required this.id,
      required this.name,
      required this.otherName,
      required this.url,
      required this.category,
      required this.image,
      required this.status,
      required this.view,
      required this.follow,
      required this.description});

  set setChapterModel(ChapterModel chapterModel) {
    this.chapterModel = chapterModel;
  }

  get getChapterModel {
    return chapterModel;
  }
}
