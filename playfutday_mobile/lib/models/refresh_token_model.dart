class RefreshTokenModel {
  String? refreshToken;

  RefreshTokenModel({this.refreshToken});

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    return data;
  }
}