class UserModel {
  final String fullName;
  final String username;
  final DateTime dateOfBirth;

  UserModel({
    required this.fullName,
    required this.username,
    required this.dateOfBirth,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['full_name'],
      username: map['username'],
      dateOfBirth: DateTime.parse(map['tgl_lahir']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'username': username,
      'tgl_lahir': dateOfBirth.toIso8601String(),
    };
  }
}
