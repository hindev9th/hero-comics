import 'package:test_app/models/comic_model.dart';

class ComicResponse {
  int? totalItem;
  int? sizePage;
  int? totalPage;
  int? currentSize;
  List<ComicModel>? list;
  int? currentPage;

  ComicResponse(
      {this.totalItem,
      this.sizePage,
      this.totalPage,
      this.currentSize,
      this.list,
      this.currentPage});

  factory ComicResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'total_item': int totalItem,
        'size_page': int sizePage,
        'total_page': int totalPage,
        'current_size': int currentSize,
        'current_page': int currentPage,
      } =>
        ComicResponse(
          totalItem: totalItem,
          sizePage: sizePage,
          totalPage: totalPage,
          currentSize: currentSize,
          currentPage: currentPage,
          list: (json["list"] as List)
              .map((e) => ComicModel.fromJson(e))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load Data.'),
    };
  }
}
