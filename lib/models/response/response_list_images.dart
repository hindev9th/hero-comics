import 'package:dart_json_mapper/dart_json_mapper.dart';

@JsonSerializable()
class ListImages {
  bool? state;
  bool? block;
  List<String>? data;
  ListImages(this.data,this.block,this.state);
}