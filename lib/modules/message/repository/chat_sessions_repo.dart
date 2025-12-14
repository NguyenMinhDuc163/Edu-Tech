import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/message/model/sessions_response.dart';
import 'package:ed_tech/modules/message/model/session_messages_response.dart';

class ChatSessionsRepo {
  final ApiClient apiClient;

  ChatSessionsRepo({required this.apiClient});

  Future<SessionsResponse> getSessions({
    int page = 1,
    int limit = 10,
  }) async {
    final res = await apiClient.fetch(
      '${ApiPath.chatSessions}?page=$page&limit=$limit',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to get sessions: ${res.message}');
    }

    final response = SessionsResponse.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Lấy danh sách phiên chat thất bại');
    }

    return response;
  }

  Future<SessionMessagesResponse> getSessionMessages({
    required String sessionId,
    int limit = 50,
  }) async {
    final res = await apiClient.fetch(
      '${ApiPath.chatSessions}/$sessionId/messages?limit=$limit',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw Exception('Failed to get session messages: ${res.message}');
    }

    final response = SessionMessagesResponse.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Lấy tin nhắn thất bại');
    }

    return response;
  }

  Future<void> deleteSession({required String sessionId}) async {
    final res = await apiClient.fetch(
      ApiPath.chatSessions,
      RequestMethod.delete,
      data: {'session_id': sessionId},
    );

    if (res.code != 200) {
      throw Exception('Failed to delete session: ${res.message}');
    }

    final json = res.json;
    if (json['status'] != 200) {
      throw Exception(json['message'] ?? 'Xóa phiên chat thất bại');
    }
  }
}
