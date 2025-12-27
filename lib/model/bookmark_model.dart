import 'package:meowmedia/model/berita_model.dart';

class BookmarkModel {
  final int idBookmark;
  final String userId;
  final BeritaModel berita;
  final DateTime createdAt;

  BookmarkModel({
    required this.idBookmark,
    required this.userId,
    required this.berita,
    required this.createdAt,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      idBookmark: map['id_bookmark'],
      userId: map['id_user'],
      berita: BeritaModel.fromMap(map['berita']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
