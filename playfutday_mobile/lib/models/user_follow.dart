class UserFollowResponse {
  late final List<UserFollow> userFollow;
  late int totalPages;
  late int totalElements;

  UserFollowResponse({required this.userFollow, required this.totalPages, required this.totalElements});

  UserFollowResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      userFollow = <UserFollow>[];
      json['content'].forEach((v) {
        userFollow!.add(new UserFollow.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userFollow != null) {
      data['content'] = this.userFollow!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;

    return data;
  }
}

class UserFollow {
  String? id;
  String? username;
  String? avatar;

  UserFollow({this.id, this.username, this.avatar});

  UserFollow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    return data;
  }
}
