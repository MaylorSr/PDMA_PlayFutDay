class ChatResponse {
  List<Chat>? content;
  int? totalPages;
  int? totalElements;

  ChatResponse({this.content, this.totalPages, this.totalElements});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Chat>[];
      json['content'].forEach((v) {
        content!.add(Chat.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    return data;
  }
}

class Chat {
  int? id;
  String? avatarUserDestinity;
  String? usernameUserDestinity;
  String? lastMessage;
  String? createdChat;
  String? idUserDestiny;
  Chat(
      {this.id,
      this.avatarUserDestinity,
      this.usernameUserDestinity,
      this.lastMessage,
      this.createdChat,
      this.idUserDestiny});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatarUserDestinity = json['avatarUserDestinity'];
    usernameUserDestinity = json['usernameUserDestinity'];
    lastMessage = json['lastMessage'];
    createdChat = json['createdChat'];
    idUserDestiny = json['idUserDestiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatarUserDestinity'] = avatarUserDestinity;
    data['usernameUserDestinity'] = usernameUserDestinity;
    data['lastMessage'] = lastMessage;
    data['createdChat'] = createdChat;
     data['idUserDestiny'] = idUserDestiny;

    return data;
  }
}
