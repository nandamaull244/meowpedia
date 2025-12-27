class KategoriModel {
  final int id;
  final String nama;

  KategoriModel({
    required this.id,
    required this.nama,
  });

  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    return KategoriModel(
      id: map['id_kategori'],
      nama: map['nama_kategori'],
    );
  }
}
