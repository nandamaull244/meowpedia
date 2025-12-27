import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meowmedia/model/bookmark_model.dart';

class BookmarkService {
  static final _supabase = Supabase.instance.client;

  /// 1️⃣ Tambah bookmark
  static Future<void> addBookmark(int beritaId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _supabase.from('bookmark').insert({
      'id_user': userId,
      'id_berita': beritaId,
    });
  }

  /// 2️⃣ Hapus bookmark
  static Future<void> removeBookmark(int beritaId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _supabase
        .from('bookmark')
        .delete()
        .eq('id_user', userId)
        .eq('id_berita', beritaId);
  }

  /// 3️⃣ Cek apakah sudah dibookmark
  static Future<bool> isBookmarked(int beritaId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('bookmark')
        .select('id_bookmark')
        .eq('id_user', userId)
        .eq('id_berita', beritaId)
        .maybeSingle();

    return response != null;
  }

  /// 4️⃣ Ambil semua bookmark user (JOIN ke berita)
  static Future<List<BookmarkModel>> getUserBookmarks() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _supabase
        .from('bookmark')
        .select('''
          id_bookmark,
          created_at,
          berita:id_berita (
            id_berita,
            judul,
            isi_berita,
            created_at,
            kategori:id_kategori (nama_kategori),
            users:id_user (username, full_name),
            gambar:id_gambar (image_url)
          )
        ''')
        .eq('id_user', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => BookmarkModel.fromMap(e))
        .toList();
  }
}
