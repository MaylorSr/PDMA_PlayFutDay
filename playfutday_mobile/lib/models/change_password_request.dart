class ChangePasswordRequest {
  String? oldPassword;
  String? newPassword;
  String? verifyNewPassword;

  ChangePasswordRequest(
      {this.oldPassword, this.newPassword, this.verifyNewPassword});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
    verifyNewPassword = json['verifyNewPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oldPassword'] = oldPassword;
    data['newPassword'] = newPassword;
    data['verifyNewPassword'] = verifyNewPassword;
    return data;
  }
}