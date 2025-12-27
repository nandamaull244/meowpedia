class BeritaModel {
  final int id;
  final String judul;
  final String isi;
  final String kategoriNama;
  final String username;
  final String full_name;
  final String imageUrl;
  final DateTime tanggal;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategoriNama,
    required this.username,
    required this.full_name,
    required this.imageUrl,
    required this.tanggal,
  });

  factory BeritaModel.fromMap(Map<String, dynamic> map) {
    final kategori = map['kategori'];
    final users = map['users'];
    final gambar = map['gambar'];

    return BeritaModel(
      id: map['id_berita'],
      judul: map['judul'],
      isi: map['isi_berita'],
      kategoriNama: kategori?['nama_kategori'] ?? '-',
      username: users?['username'] ?? users?['full_name'] ?? '-',
      full_name: users?['full_name'] ?? '-',
      imageUrl: gambar?['image_url'] ??
          'https://via.placeholder.com/300',
      tanggal: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }
}
