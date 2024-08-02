import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/chapter_model.dart';

@JsonSerializable()
class ListChapters {
  @JsonProperty(name: "chapters")
  List<Chapter>? chapters;
  int? limit;
}
