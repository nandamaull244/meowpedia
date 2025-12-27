import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/berita_model.dart';

class BeritaServiceUser {
  static final _supabase = Supabase.instance.client;

  /// =============================
  /// GET BERITA MILIK USER LOGIN
  /// =============================
  static Future<List<BeritaModel>> getBeritaUser() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _supabase
        .from('berita')
        .select('''
          id_berita,
          judul,
          isi_berita,
          created_at,
          kategori:id_kategori (
            nama_kategori
          ),
          users:id_user (
            username,
            full_name
          ),
          gambar: id_gambar (
            nama_file,
            image_url

          )
        ''')
        .eq('id_user', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => BeritaModel.fromMap(e))
        .toList();
  }


    /// =============================
  /// DELETE BERITA USER
  /// =============================
  static Future<void> deleteBerita(int beritaId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    // 1. Ambil path gambar
    final data = await _supabase
        .from('berita')
        .select('gambar: id_gambar (image_url)')
        .eq('id_berita', beritaId)
        .eq('id_user', userId)
        .single();

    final storagePath = data['gambar']['image_url'];

    // 2. Hapus file storage
    if (storagePath != null) {
      await _supabase.storage
          .from('berita')
          .remove([storagePath]);
    }

    // 3. Hapus berita
    await _supabase
        .from('berita')
        .delete()
        .eq('id_berita', beritaId)
        .eq('id_user', userId);
  }

}
