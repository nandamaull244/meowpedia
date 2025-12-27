import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> uploadBerita({
    required Uint8List imageBytes,
    required String judul,
    required String isi,
    required int kategoriId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    // =====================
    // 1️⃣ UPLOAD IMAGE
    // =====================
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final filePath = 'gambar/$fileName';

    await _supabase.storage
        .from('berita-images') // 🔥 NAMA BUCKET
        .uploadBinary(
          filePath,
          imageBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
          ),
        );

    final imageUrl = _supabase.storage
        .from('berita-images')
        .getPublicUrl(filePath);

    // =====================
    // 2️⃣ INSERT MEDIA
    // =====================
    final mediaData = await _supabase
        .from('gambar')
        .insert({
          'nama_file': fileName,
          'image_url': imageUrl,
        })
        .select()
        .single();

    // =====================
    // 3️⃣ INSERT BERITA
    // =====================
    await _supabase.from('berita').insert({
      'judul': judul,
      'isi_berita': isi,
      'id_kategori': kategoriId,
      'id_gambar': mediaData['id_gambar'],
      'id_user': user.id,
    });
  }
}
