import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/message/model/chat_response.dart';

class ChatBotRepo {
  final ApiClient apiClient;

  ChatBotRepo({required this.apiClient});

  Future<ChatResponse> sendMessage({
    required String message,
    String? sessionId,
    String? courseId,
    String? contentId,
    String? customUrl,
  }) async {
    final res = await apiClient.fetch(
      ApiPath.chatBot,
      RequestMethod.post,
      rawData: {
        "prompt": message,
        if (sessionId != null) "session_id": sessionId,
        if (courseId != null) "course_id": courseId,
        if (contentId != null) "content_id": contentId,
        if (customUrl != null) "custom_url": customUrl,
      },
    );

    if (res.code != 200) {
      throw Exception('Failed to send message: ${res.message}');
    }

    final response = ChatResponse.fromJson(res.json);

    if (response.status != 200) {
      throw Exception(response.message ?? 'Gửi tin nhắn thất bại');
    }

    return response;
  }
}
