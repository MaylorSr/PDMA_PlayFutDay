// ignore_for_file: file_names

class Error {
  String? status;
  String? message;
  String? path;
  int? statusCode;
  String? date;
  List<SubErrors>? subErrors;

  Error(
      {this.status,
      this.message,
      this.path,
      this.statusCode,
      this.date,
      this.subErrors});

  Error.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    path = json['path'];
    statusCode = json['statusCode'];
    date = json['date'];
    if (json['subErrors'] != null) {
      subErrors = <SubErrors>[];
      json['subErrors'].forEach((v) {
        subErrors!.add(SubErrors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['path'] = path;
    data['statusCode'] = statusCode;
    data['date'] = date;
    if (subErrors != null) {
      data['subErrors'] = subErrors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubErrors {
  String? object;
  String? message;
  String? field;
  String? rejectedValue;

  SubErrors({this.object, this.message, this.field, this.rejectedValue});

  SubErrors.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    message = json['message'];
    field = json['field'];
    rejectedValue = json['rejectedValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['object'] = object;
    data['message'] = message;
    data['field'] = field;
    data['rejectedValue'] = rejectedValue;
    return data;
  }
}
