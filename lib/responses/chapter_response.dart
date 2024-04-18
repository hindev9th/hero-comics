import 'package:test_app/models/chapter_model.dart';

class ChapterResponse{
  int? success;
  List<ChapterModel>? chapters;

  ChapterResponse({this.success,this.chapters});

  factory ChapterResponse.fromJson(Map<String, dynamic> json){
    return  ChapterResponse(
            chapters: json["chapters"] != null ? (json["chapters"] as List).map((e) => ChapterModel.fromJsonApi(e)).toList() : [],
          );
  }
}