import 'dart:io';

class EditDataUser {
  String? phone;
  String? biography;
  String? birthday;
  File? avatar;
  EditDataUser({this.phone, this.biography, this.birthday, this.avatar});

  EditDataUser.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    biography = json['biography'];
    birthday = json['birthday'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['biography'] = biography;
    data['birthday'] = birthday;
    data['avatar'] = avatar;
    return data;
  }
}
