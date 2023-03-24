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
      this.token});

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
        myPost!.add(new MyPost.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['biography'] = this.biography;
    data['phone'] = this.phone;
    data['birthday'] = this.birthday;
    if (this.myPost != null) {
      data['myPost'] = myPost!.map((v) => v.toJson()).toList();
    }
    data['roles'] = this.roles;
    data['token'] = this.token;
    return data;
  }
}

class MyPost {
  int? id;
  String? tag;
  String? image;
  String? uploadDate;
  String? author;
  int? countLikes;
  List<UserCommentaries>? commentaries;

  MyPost(
      {this.id,
      this.tag,
      this.image,
      this.uploadDate,
      this.author,
      this.countLikes,
      this.commentaries});

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    image = json['image'];
    uploadDate = json['uploadDate'];
    author = json['author'];
    countLikes = json['countLikes'];
    if (json['commentaries'] != null) {
      commentaries = <UserCommentaries>[];
      json['commentaries'].forEach((v) {
        commentaries!.add(new UserCommentaries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['image'] = this.image;
    data['uploadDate'] = this.uploadDate;
    data['author'] = this.author;
    data['countLikes'] = this.countLikes;
    if (this.commentaries != null) {
      data['commentaries'] = this.commentaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserCommentaries {
  String? message;
  String? authorName;
  String? uploadCommentary;

  UserCommentaries({this.message, this.authorName, this.uploadCommentary});

  UserCommentaries.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    authorName = json['authorName'];
    uploadCommentary = json['uploadCommentary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['authorName'] = this.authorName;
    data['uploadCommentary'] = this.uploadCommentary;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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