import 'dart:ffi';

class ChapterModel {
  String? id;
  String? name;
  String? url;
  String? time;

  ChapterModel({this.id, this.name, this.url, this.time});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["url"] is String) {
      url = json["url"];
    }
    if (json["time"] is String) {
      time = json["time"];
    }
  }

  ChapterModel.fromJsonApi(Map<String, dynamic> json) {
    if (json["chapterId"] is Int) {
      id = json["chapterId"].toString();
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["url"] is String) {
      url = json["url"];
    }
  }

  static List<ChapterModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => ChapterModel.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["url"] = url;
    _data["time"] = time;
    return _data;
  }
}
