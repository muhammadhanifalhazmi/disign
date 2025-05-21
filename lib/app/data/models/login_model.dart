class Login {
  String? username;
  String? password;
  String? hwid;

  Login({this.username, this.password, this.hwid});

  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    hwid = json['hwid'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['hwid'] = hwid;
    return data;
  }
}
