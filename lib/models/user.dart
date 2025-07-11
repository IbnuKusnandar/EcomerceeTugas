class User {
  final String id, username, password, fullName;
  User({required this.id, required this.username, required this.password, required this.fullName});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      fullName: json['fullName'],
    );
  }
}
