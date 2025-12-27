class BeritaModel {
  final int id;
  final String judul;
  final String isi;
  final String kategoriNama;
  final String username;
  final String imageUrl;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategoriNama,
    required this.username,
    required this.imageUrl,
  });

  factory BeritaModel.fromMap(Map<String, dynamic> map) {
    return BeritaModel(
      id: map['berita_id'],
      judul: map['judul_berita'],
      isi: map['isi_berita'],
      kategoriNama: map['kategori']['nama_kategori'],
      username: map['user']['username'] ?? map['user']['full_name'],
      imageUrl: map['media']['image_url'],
    );
  }
}
