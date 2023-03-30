class EditDataUser {
  String? phone;
  String? biography;
  String? birthday;

  EditDataUser({this.phone, this.biography, this.birthday});

  EditDataUser.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    biography = json['biography'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = phone;
    data['biography'] = biography;
    data['birthday'] = birthday;
    return data;
  }
}
