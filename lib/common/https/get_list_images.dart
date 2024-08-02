import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:test_app/common/http_api.dart';
import 'package:test_app/common/https/get_list_images_html.dart';
import 'package:test_app/models/response/response_list_images.dart';
import 'package:test_app/models/response/response_page.dart';

Future<ResponsePage?> getImages(
    String id, String numberChapter, String nameEn) async {
  try {
    final response = await postRequest("/api/chapter/auth",
        'comicId=$id&chapterNumber=$numberChapter&nameEn=$nameEn',
        {"content-type": "application/x-www-form-urlencoded; charset=UTF-8"});
    final result = JsonMapper.deserialize<ResponsePage>(response);

    if (result!.result!.data == null) {
      final images = await getImagesHtml("/truyen/$nameEn/chuong-$numberChapter");
      ListImages listImages = ListImages(images, false, false);
      ResponsePage responsePage = ResponsePage(listImages, true, 200);
      return responsePage;
    }
    return result;
  } catch (e) {
    throw Exception('Failed to load data $e');
  }
}
