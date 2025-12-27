class MediaModel {
  final int id;
  final String namaFile;
  final String imageUrl;

  MediaModel({
    required this.id,
    required this.namaFile,
    required this.imageUrl,
  });

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id_gambar'],
      namaFile: map['nama_file'],
      imageUrl: map['image_url'],
    );
  }
}
