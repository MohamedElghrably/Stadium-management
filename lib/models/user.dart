class UserModel {
  String id;
  final String username;
  final String phone;

  UserModel({required this.id, required this.username, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'phone': phone};
  }

  UserModel copyWith({String? id, String? username, String? phone}) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
    );
  }
}
