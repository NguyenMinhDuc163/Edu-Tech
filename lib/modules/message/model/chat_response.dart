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
  ChatData({required this.answer, required this.rawAnswer});

  final String? answer;
  final String? rawAnswer;

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(answer: json["answer"], rawAnswer: json["rawAnswer"]);
  }

  Map<String, dynamic> toJson() => {"answer": answer, "rawAnswer": rawAnswer};

  @override
  String toString() {
    return "$answer, $rawAnswer, ";
  }
}
