
class ChapterModel {
  String? id;
  String? name;
  String? url;
  String? time;

  ChapterModel({this.id, this.name, this.url, this.time});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
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
    id = json["id"].toString();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["url"] = url;
    data["time"] = time;
    return data;
  }
}
