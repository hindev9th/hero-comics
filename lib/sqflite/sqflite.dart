import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _singleton = DbHelper._internal();
  late Database database;

  factory DbHelper() {
    return _singleton;
  }

  DbHelper._internal();

  Future<void> initDB() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'comics-app.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE hr_histories (comic_id TEXT, chapter_id TEXT)');
    });
  }

  Future<void> insertHistory(String comicId, String chapterId) async {
    await database
        .insert('hr_histories', {'comic_id': comicId, 'chapter_id': chapterId});
  }

  Future<void> updateHistory(String comicId, String chapterId) async {
    await database.update('hr_histories', {'chapter_id': chapterId},
        where: 'comic_id = ?', whereArgs: [comicId]);
  }

  Future<Map<String, dynamic>> getHistory(String comicId) async {
    List<Map<String, dynamic>> history = await database.query('hr_histories',
        limit: 1, where: 'comic_id = ?', whereArgs: [comicId]);

    if (history.isNotEmpty) {
      return history.first;
    } else {
      return {
        'comic_id': '0',
        'chapter_id': '0',
      };
    }
  }

  Future<void> upsertHistory(String comicId, String chapterId) async {
    Map<String, dynamic> history = await getHistory(comicId);

    if (history['comic_id'] != '0') {
      await updateHistory(comicId, chapterId);
    } else {
      await insertHistory(comicId, chapterId);
    }
  }
}
