import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/models/response/response_list_images.dart';

@jsonSerializable
class ResponsePage{
  bool? status;
  int? code;
  ListImages? result;

  ResponsePage(this.result,this.status,this.code);
}