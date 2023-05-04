// ignore: file_names
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
        myPost!.add(MyPost.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
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
        commentaries!.add(Commentaries.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    data['image'] = image;
    data['uploadDate'] = uploadDate;
    data['author'] = author;
    data['idAuthor'] = idAuthor;
    data['authorFile'] = authorFile;
    data['likesByAuthor'] = likesByAuthor;
    data['countLikes'] = countLikes;
    if (commentaries != null) {
      data['commentaries'] = commentaries!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['authorName'] = authorName;
    data['authorFile'] = authorFile;
    data['uploadCommentary'] = uploadCommentary;
    return data;
  }
}
