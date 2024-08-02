import 'package:dart_json_mapper/dart_json_mapper.dart';


@jsonSerializable
class Comic {
  String id;String name;
  String description;
  String otherName;
  String statusCode;
  String photo;
  String nameEn;
  bool display;
  String author;
  String novelId;
  List<String> chapterLatest;
  List<String> chapterLatestId;
  List<String> chapterLatestDate;
  List<String> chapterState;
  dynamic category;
  dynamic categoryCode;
  DateTime createDate;
  DateTime updateDate;
  dynamic note;
  String followerCount;
  String viewCount;
  double evaluationScore;

  Comic({
    required this.id,
    required this.name,
    required this.description,
    required this.otherName,
    required this.statusCode,
    required this.photo,
    required this.nameEn,
    required this.display,
    required this.author,
    required this.novelId,
    required this.chapterLatest,
    required this.chapterLatestId,
    required this.chapterLatestDate,
    required this.chapterState,
    this.category,
    this.categoryCode,
    required this.createDate,
    required this.updateDate,
    this.note,
    required this.followerCount,
    required this.viewCount,
    required this.evaluationScore,
  });
}