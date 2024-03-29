class ModelUser {
  String username;
  String name;
  String email;
  String password;
  String uid;

  ModelUser({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "uid": uid,
        "password": password,
        "whoIs": "student",
      };
}
