import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/kategori_model.dart';

class KategoriService {
  final _supabase = Supabase.instance.client;

  Future<List<KategoriModel>> getKategori() async {
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori');

    return response
        .map<KategoriModel>((e) => KategoriModel.fromMap(e))
        .toList();
  }
}
