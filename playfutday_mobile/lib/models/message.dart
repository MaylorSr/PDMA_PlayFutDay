class MessageResponse {
  List<Message>? content;
  int? totalPages;
  int? totalElements;

  MessageResponse({this.content, this.totalPages, this.totalElements});

  MessageResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Message>[];
      json['content'].forEach((v) {
        content!.add(new Message.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class Message {
  int? id;
  String? idUserWhoSendMessage;
  String? usernameWhoSendMessage;
  String? avatarWhoSendMessage;
  String? bodyMessage;
  String? timeWhoSendMessage;

  Message(
      {this.id,
      this.idUserWhoSendMessage,
      this.usernameWhoSendMessage,
      this.avatarWhoSendMessage,
      this.bodyMessage,
      this.timeWhoSendMessage});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUserWhoSendMessage = json['idUserWhoSendMessage'];
    usernameWhoSendMessage = json['usernameWhoSendMessage'];
    avatarWhoSendMessage = json['avatarWhoSendMessage'];
    bodyMessage = json['bodyMessage'];
    timeWhoSendMessage = json['timeWhoSendMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idUserWhoSendMessage'] = this.idUserWhoSendMessage;
    data['usernameWhoSendMessage'] = this.usernameWhoSendMessage;
    data['avatarWhoSendMessage'] = this.avatarWhoSendMessage;
    data['bodyMessage'] = this.bodyMessage;
    data['timeWhoSendMessage'] = this.timeWhoSendMessage;
    return data;
  }
}