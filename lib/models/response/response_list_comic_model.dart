import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/comic_model.dart';

@JsonSerializable()
class ListComic {
  @JsonProperty(name: "data")
  List<Comic>? data;
  int? p;
  int? limit;
  bool? next;
}
