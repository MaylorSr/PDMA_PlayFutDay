class UserInfo {
  String? id;
  String? username;
  String? email;
  String? avatar;
  String? biography;
  String? phone;
  String? birthday;
  List<MyPost>? myPost;
  List<String>? roles;

  UserInfo(
      {this.id,
      this.username,
      this.email,
      this.avatar,
      this.biography,
      this.phone,
      this.birthday,
      this.myPost,
      this.roles});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
      data['myPost'] = this.myPost!.map((v) => v.toJson()).toList();
    }
    data['roles'] = this.roles;
    return data;
  }
}

class MyPost {
  int? id;
  String? tag;
  String? image;
  String? uploadDate;
  String? author;
  String? idAuthor;
  String? authorFile;
  List<String>? likesByAuthor;
  int? countLikes;
  List<Commentaries>? commentaries;
  String? description;

  MyPost(
      {this.id,
      this.tag,
      this.image,
      this.uploadDate,
      this.author,
      this.idAuthor,
      this.authorFile,
      this.likesByAuthor,
      this.countLikes,
      this.commentaries,
      this.description});

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    image = json['image'];
    uploadDate = json['uploadDate'];
    author = json['author'];
    idAuthor = json['idAuthor'];
    authorFile = json['authorFile'];
    likesByAuthor = (json['likesByAuthor'] != null)
        ? likesByAuthor =
            (json['likesByAuthor'] as List<dynamic>).cast<String>()
        : likesByAuthor = (json['likesByAuthor']);
    countLikes = json['countLikes'];
    if (json['commentaries'] != null) {
      commentaries = <Commentaries>[];
      json['commentaries'].forEach((v) {
        commentaries!.add(new Commentaries.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['image'] = this.image;
    data['uploadDate'] = this.uploadDate;
    data['author'] = this.author;
    data['idAuthor'] = this.idAuthor;
    data['authorFile'] = this.authorFile;
    data['likesByAuthor'] = this.likesByAuthor;
    data['countLikes'] = this.countLikes;
    if (this.commentaries != null) {
      data['commentaries'] = this.commentaries!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    return data;
  }
}

class Commentaries {
  String? message;
  String? authorName;
  String? authorFile;
  String? uploadCommentary;

  Commentaries(
      {this.message, this.authorName, this.authorFile, this.uploadCommentary});

  Commentaries.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    authorName = json['authorName'];
    authorFile = json['authorFile'];
    uploadCommentary = json['uploadCommentary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['authorName'] = this.authorName;
    data['authorFile'] = this.authorFile;
    data['uploadCommentary'] = this.uploadCommentary;
    return data;
  }
}
