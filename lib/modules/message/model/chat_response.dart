class ChatResponse {
  ChatResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final ChatData? data;

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : ChatData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }
}

class ChatData {
  ChatData({
    required this.sessionId,
    required this.responseHtml,
    required this.responseRaw,
  });

  final String? sessionId;
  final String? responseHtml;
  final String? responseRaw;

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      sessionId: json["session_id"],
      responseHtml: json["response_html"],
      responseRaw: json["response_raw"],
    );
  }

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "response_html": responseHtml,
        "response_raw": responseRaw,
      };

  @override
  String toString() {
    return "$sessionId, $responseHtml, $responseRaw, ";
  }
}
