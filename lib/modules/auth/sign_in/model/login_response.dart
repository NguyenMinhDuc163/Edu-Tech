class LoginResponse {
  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final Data? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $message, $data, ";
  }
}

class Data {
  Data({
    required this.accessToken,
  });

  final String? accessToken;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      accessToken: json["access_token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
  };

  @override
  String toString(){
    return "$accessToken, ";
  }
}
