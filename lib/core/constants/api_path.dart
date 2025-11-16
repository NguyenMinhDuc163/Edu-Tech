import 'package:envied/envied.dart';

import 'environment_files.dart';

part 'api_path.g.dart';

@Envied(path: pathToEnv, requireEnvFile: true)
class ApiPath {
  /// Base URL
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  // static String baseUrl = _ApiPath.baseUrl;
  static String baseUrl = "http://172.17.53.17:3000";
  @EnviedField(varName: 'REGISTER_ID', obfuscate: true)
  static String registerId = _ApiPath.registerId;

  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  static const String publicCourse = '/student/courses';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String loginSocial = '/auth/login-social';
  static const String checkUserName = '/auth/check-username-exist';
  static const String checkMail = '/auth/check-email-exist';
  static const String chatBot = '/chat';
  static const String listQuiz = '/student/quiz/list';
  static const String quizDetail = '/student/quiz/detail';
  static const String submitQuiz = '/student/quiz/submit';
  static const String quizHistory = '/student/quiz/history';
  static const String searchCourses = '/search/courses';
  static const String searchHistory = '/search/history';
  static const String createPayment = '/api/create-qr';
  static const String studentRegistrations = '/student/registrations';
}

// TODO trong intercepter => ds api can truyen id
// TODO o trong path chi dinh san ky tu => nhan dien duoc de truyen them id
// TODO tim hieu app error state
