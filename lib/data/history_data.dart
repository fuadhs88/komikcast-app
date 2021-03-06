import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:komikcast/bloc/history_bloc.dart';
import 'package:komikcast/data/comic_data.dart';
import 'package:komikcast/models/detail_chapter.dart';

class HistoryData {
  static saveHistory({
    String mangaId,
    String currentId,
    DetailChapter detailChapter,
  }) async {
    // Open DB
    // ============================
    var db = Hive.box('komikcast');

    // Get Values
    // ============================
    List listHistory = db.get('history') != null ? db.get('history') : [];
    listHistory = listHistory.cast<Map>();

    // Get detail komik parent
    // ============================
    var comicData = await ComicData.getDetailKomik(id: mangaId);

    // Store History to DB
    // ============================
    var history = {
      'image': comicData.image,
      'title': comicData.title,
      'mangaId': mangaId,
      'chapterId': currentId,
      'chapterName': detailChapter.chapter,
    };

    listHistory = listHistory
        .where((element) => element['chapterId'] != currentId)
        .toList();

    listHistory.add(history);
    db.put('history', listHistory);

    // Store History to Bloc
    // ================================
    Modular.get<HistoryBloc>().add(listHistory);

    // print('history-saved');
  }
}
