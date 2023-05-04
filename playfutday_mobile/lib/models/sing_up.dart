class RegisterRequest {
  String? username;
  String? email;
  String? phone;
  String? password;
  String? verifyPassword;

  RegisterRequest({
    this.username,
    this.email,
    this.phone,
    this.password,
    this.verifyPassword,
  });

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['verifyPassword'] = verifyPassword;
    return data;
  }
}