import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/berita_model.dart';

class BeritaService {
  static final _supabase = Supabase.instance.client;

  /// =============================
  /// GET BERITA MILIK USER LOGIN
  /// =============================
  Future<List<BeritaModel>> getAllBerita() async {
  final response = await _supabase
      .from('berita')
      .select('''
        id_berita,
        judul,
        isi_berita,
        created_at,
        kategori:kategori!berita_id_kategori_fkey (
          id_kategori,
          nama_kategori
        ),
        users:users!berita_id_user_fkey (
          username,
          full_name
        ),
        gambar:gambar!berita_id_gambar_fkey (
          image_url
        )
      ''')
      .order('created_at', ascending: false);

  return (response as List)
      .map((e) => BeritaModel.fromMap(e))
      .toList();
}



    /// =============================
  /// DELETE BERITA USER
  /// =============================
  Future<List<BeritaModel>> getBeritaByKategori(int kategoriId) async {
  final response = await _supabase
      .from('berita')
      .select('''
        id_berita,
        judul,
        isi_berita,
        created_at,
        kategori:kategori!berita_id_kategori_fkey (
          id_kategori,
          nama_kategori
        ),
        users:users!fk_user (
          username,
          full_name
        ),
        gambar:gambar!fk_gambar (
          image_url
        )
      ''')
      .eq('id_kategori', kategoriId)
      .order('created_at', ascending: false);

  return (response as List)
      .map((e) => BeritaModel.fromMap(e))
      .toList();
}


}
