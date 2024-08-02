
import 'package:dart_json_mapper/dart_json_mapper.dart';

@JsonSerializable()
class Chapter {
  String? id;
  String? name;
  String? comicName;
  String? comicOtherName;
  String? limit;
  String? comicId;
  String? type;
  int? viewCount;
  String? numberChapter;
  String? translationTeam;
  int? updateTime;
  String? stringUpdateTime;
  int? rangeBlock;
  String? randomCode;
  String? randomPosition;
  bool? display;
  bool? ajax;
  bool? cdn;
  bool? video;
  String? urlVideo;
  String? serversName;

  Chapter({this.id,
    this.name,
    this.comicName,
    this.comicOtherName,
    this.limit,
    this.comicId,
    this.type,
    this.viewCount,
    this.numberChapter,
    this.translationTeam,
    this.updateTime,
    this.stringUpdateTime,
    this.rangeBlock,
    this.randomCode,
    this.randomPosition,
    this.display,
    this.ajax,
    this.cdn,
    this.video,
    this.urlVideo,
    this.serversName});
}