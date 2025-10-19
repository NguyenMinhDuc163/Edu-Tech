class LoginResponse {
  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
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
    required this.refreshToken,
    required this.user,
  });

  final String? accessToken;
  final String? refreshToken;
  final User? user;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "user": user?.toJson(),
  };

  @override
  String toString(){
    return "$accessToken, $refreshToken, $user, ";
  }
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  final String? id;
  final String? username;
  final String? email;
  final String? role;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "role": role,
  };

  @override
  String toString(){
    return "$id, $username, $email, $role, ";
  }
}
