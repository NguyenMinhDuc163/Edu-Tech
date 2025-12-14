class SessionsResponse {
  SessionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final SessionsData? data;

  factory SessionsResponse.fromJson(Map<String, dynamic> json) {
    return SessionsResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : SessionsData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class SessionsData {
  SessionsData({
    required this.sessions,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<ChatSession> sessions;
  final int total;
  final int page;
  final int limit;

  factory SessionsData.fromJson(Map<String, dynamic> json) {
    return SessionsData(
      sessions: json["sessions"] == null
          ? []
          : List<ChatSession>.from(
              json["sessions"].map((x) => ChatSession.fromJson(x))),
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        "sessions": sessions.map((x) => x.toJson()).toList(),
        "total": total,
        "page": page,
        "limit": limit,
      };
}

class ChatSession {
  ChatSession({
    required this.sessionId,
    required this.createdAt,
    required this.lastActiveAt,
    required this.messageCount,
    required this.firstMessage,
  });

  final String sessionId;
  final DateTime? createdAt;
  final DateTime? lastActiveAt;
  final int messageCount;
  final String firstMessage;

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json["session_id"] ?? '',
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      lastActiveAt: json["last_active_at"] == null
          ? null
          : DateTime.parse(json["last_active_at"]),
      messageCount: json["message_count"] ?? 0,
      firstMessage: json["first_message"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "created_at": createdAt?.toIso8601String(),
        "last_active_at": lastActiveAt?.toIso8601String(),
        "message_count": messageCount,
        "first_message": firstMessage,
      };
}
