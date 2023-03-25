// ignore_for_file: file_names, unnecessary_new

import 'package:equatable/equatable.dart';

class PostResponse {
  late final List<Post> content;
  late int totalPages;
  PostResponse({required this.content, required this.totalPages});

  PostResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Post>[];
      json['content'].forEach((v) {
        // ignore: unnecessary_new
        content!.add(new Post.fromJson(v));
      });
      totalPages = json['totalPages'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;

    return data;
  }
}

// ignore: must_be_immutable
class Post extends Equatable {
  late int id;
  String? tag;
  String? description;
  String? image;
  String? uploadDate;
  late String author;
  late String idAuthor;
  String? authorFile;
  List<String>? likesByAuthor;
  int? countLikes;
  List<Commentaries>? commentaries;

  Post(
      {required this.id,
      this.tag,
      this.description,
      this.image,
      this.uploadDate,
      required this.author,
      required this.idAuthor,
      this.authorFile,
      this.likesByAuthor,
      this.countLikes,
      this.commentaries});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    description = json['description'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['description'] = this.description;
    data['image'] = this.image;
    data['uploadDate'] = this.uploadDate;
    data['author'] = this.author;
    data['idAuthor'] = this.idAuthor;
    data['authorFile'] = this.authorFile;
    data['likesByAuthor'] = this.likesByAuthor;
    data['countLikes'] = countLikes;
    if (this.commentaries != null) {
      data['commentaries'] = this.commentaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Post copyWith(List<String>? likesByAuthor, int? countLikes,
      List<Commentaries>? commentaries) {
    return Post(
        id: id,
        tag: tag,
        description: description,
        image: image,
        uploadDate: uploadDate,
        author: author,
        idAuthor: idAuthor,
        authorFile: authorFile,
        likesByAuthor: likesByAuthor ?? this.likesByAuthor,
        countLikes: countLikes ?? this.countLikes,
        commentaries: commentaries ?? this.commentaries);
  }

  @override
  List<Object> get props => [];
}

class Commentaries {
  String? message;
  String? authorName;
  String? authorFile;
  String? uploadCommentary;

  Commentaries(int? id,
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
