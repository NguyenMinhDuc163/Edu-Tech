import 'dart:convert';
import 'package:sp_util/sp_util.dart';

const String _userDataKey = 'user_data';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance!;

  static Future<UserService> initialize() async {
    _instance ??= UserService._();
    await _instance!._loadUserData();
    return _instance!;
  }

  UserService._();

  UserData? _userData;
  UserData? get userData => _userData;

  Future<void> _loadUserData() async {
    final String? userJson = SpUtil.getString(_userDataKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(userJson);
        _userData = UserData.fromJson(json);
      } catch (e) {
        _userData = null;
      }
    }
  }

  Future<void> saveUserData(UserData user) async {
    _userData = user;
    final String userJson = jsonEncode(user.toJson());
    await SpUtil.putString(_userDataKey, userJson);
  }

  Future<void> clearUserData() async {
    _userData = null;
    await SpUtil.remove(_userDataKey);
  }

  String get displayName => _userData?.username ?? 'User';
  String get email => _userData?.email ?? '';
  String get role => _userData?.role ?? 'student';
}

class UserData {
  final String id;
  final String username;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
