import 'package:test_app/models/chapter_model.dart';

class ChapterResponse {
  int? status;
  String? message;
  List<ChapterModel>? chapters;

  ChapterResponse({this.status, this.chapters});

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    return ChapterResponse(
      chapters: json['data']["list"] != null
          ? (json['data']["list"] as List)
              .map((e) => ChapterModel.fromJsonApi(e))
              .toList()
          : [],
    );
  }
}
