class SessionMessagesResponse {
  SessionMessagesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final SessionMessagesData? data;

  factory SessionMessagesResponse.fromJson(Map<String, dynamic> json) {
    return SessionMessagesResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : SessionMessagesData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class SessionMessagesData {
  SessionMessagesData({
    required this.sessionId,
    required this.messages,
  });

  final String sessionId;
  final List<SessionMessage> messages;

  factory SessionMessagesData.fromJson(Map<String, dynamic> json) {
    return SessionMessagesData(
      sessionId: json["session_id"] ?? '',
      messages: json["messages"] == null
          ? []
          : List<SessionMessage>.from(
              json["messages"].map((x) => SessionMessage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "messages": messages.map((x) => x.toJson()).toList(),
      };
}

class SessionMessage {
  SessionMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.tokenCount,
  });

  final String id;
  final String role;
  final String content;
  final DateTime? createdAt;
  final int? tokenCount;

  factory SessionMessage.fromJson(Map<String, dynamic> json) {
    return SessionMessage(
      id: json["id"] ?? '',
      role: json["role"] ?? '',
      content: json["content"] ?? '',
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      tokenCount: json["token_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "token_count": tokenCount,
      };
}
