class SendMessageResponse {
  String? bodyMessage;

  SendMessageResponse({this.bodyMessage});

  SendMessageResponse.fromJson(Map<String, dynamic> json) {
    bodyMessage = json['bodyMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bodyMessage'] = this.bodyMessage;
    return data;
  }
}