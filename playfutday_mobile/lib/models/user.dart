class User {
  String? id;
  String? username;
  String? email;
  String? avatar;
  String? biography;
  String? phone;
  String? birthday;
  List<MyPost>? myPost;
  List<String>? roles;
  String? token;
  String? refreshToken;

  User(
      {this.id,
      this.username,
      this.email,
      this.avatar,
      this.biography,
      this.phone,
      this.birthday,
      this.myPost,
      this.roles,
      this.token,
      this.refreshToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    avatar = json['avatar'];
    biography = json['biography'];
    phone = json['phone'];
    birthday = json['birthday'];
    if (json['myPost'] != null) {
      myPost = <MyPost>[];
      json['myPost'].forEach((v) {
        myPost!.add(MyPost.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['avatar'] = avatar;
    data['biography'] = biography;
    data['phone'] = phone;
    data['birthday'] = birthday;
    if (myPost != null) {
      data['myPost'] = myPost!.map((v) => v.toJson()).toList();
    }
    data['roles'] = roles;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class MyPost {
  String? image;

  MyPost({this.image});

  MyPost.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    return data;
  }
}

class UserResponse extends User {
  UserResponse(id, username, avatar, token, email, biography, phone, birthday,
      myPost, roles)
      : super();
  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    biography = json['biography'];
    phone = json['phone'];
    birthday = json['birthday'];
    myPost = json['myPost'] != null
        ? (json['myPost'] as List<dynamic>)
            .map((e) => MyPost.fromJson(e))
            .toList()
        : [];
    roles = json['roles'] != null
        ? (json['roles'] as List<dynamic>).cast<String>()
        : [];
    avatar = json['avatar'];
    token = json['token'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['biography'] = biography;
    data['birthday'] = birthday;
    data['myPost'] = myPost;
    data['roles'] = roles;
    data['avatar'] = avatar;
    data['token'] = token;
    return data;
  }
}
