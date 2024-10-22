class UserModel {
  final String license;
  final String name;
  final String password;
  final String phone;
  final int type;
  final String url;

  UserModel({
    required this.license,
    required this.name,
    required this.password,
    required this.phone,
    required this.type,
    required this.url,
  });

  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      license: json['license'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      type: json['type'] as int,
      url: json['url'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'license': license,
      'name': name,
      'password': password,
      'phone': phone,
      'type': type,
      'url': url,
    };
  }
}
