class SearchHistory {
  SearchHistory({
    required this.searchId,
    required this.keyword,
    required this.createdAt,
    required this.userId,
  });

  final String? searchId;
  final String? keyword;
  final DateTime? createdAt;
  final String? userId;

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      searchId: json["search_id"],
      keyword: json["keyword"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "search_id": searchId,
        "keyword": keyword,
        "created_at": createdAt?.toIso8601String(),
        "user_id": userId,
      };
}
