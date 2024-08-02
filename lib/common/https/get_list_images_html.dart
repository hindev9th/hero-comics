import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

Future<List<String>> getImagesHtml(String url) async {
  try {
    final response = await http.get(Uri.parse(dotenv.env['PUBLIC_URL_API']! + url));
    if (response.statusCode == 200) {
      Document document = parser.parse(response.body);
      List<Element> links = document.querySelectorAll('.image');
      if (links.isEmpty) {
        return [];
      }

      List<String> urls = [];
      for (Element link in links) {
        final url = link.attributes['src'];
        if (url!.isNotEmpty) {
          urls.add(url);
        }
      }
      return urls;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}