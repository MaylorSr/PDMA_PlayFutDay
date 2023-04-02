class PostRequest {
  String? tag;
  String? description;

  PostRequest({this.tag, this.description});

  PostRequest.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tag'] = tag;
    data['description'] = description;
    return data;
  }
}