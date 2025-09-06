class UserModel {
  String id;
  final String username;
  final String phone;
  final String userType;
  final String stadiumName;

  UserModel({
    required this.id,
    required this.username,
    required this.phone,
    required this.userType,
    required this.stadiumName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? '',
      stadiumName: json['stadiumName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
      'userType': userType,
      'stadiumName': stadiumName,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? phone,
    String? userType,
    String? stadiumName,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      stadiumName: stadiumName ?? this.stadiumName,
    );
  }
}
