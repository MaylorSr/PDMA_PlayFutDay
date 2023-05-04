// ignore: file_names
class PostFavResponse {
  List<MyFavPost>? content;
  late int totalPages;

  PostFavResponse({this.content, required this.totalPages});

  PostFavResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <MyFavPost>[];
      json['content'].forEach((v) {
        content!.add(MyFavPost.fromJson(v));
      });
      totalPages = json['totalPages'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    return data;
  }
}

class MyFavPost {
  int? id;
  String? tag;
  String? image;
  String? author;
  String? authorFile;
  int? countLikes;

  MyFavPost(
      {this.id,
      this.tag,
      this.image,
      this.author,
      this.authorFile,
      this.countLikes});

  MyFavPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    image = json['image'];
    author = json['author'];
    authorFile = json['authorFile'];
    countLikes = json['countLikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    data['image'] = image;
    data['author'] = author;
    data['authorFile'] = authorFile;
    data['countLikes'] = countLikes;
    return data;
  }

  
}