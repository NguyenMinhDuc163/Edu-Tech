class AutocompleteSuggestion {
  final String? keyword;
  final String? highlighted;

  AutocompleteSuggestion({
    this.keyword,
    this.highlighted,
  });

  factory AutocompleteSuggestion.fromJson(Map<String, dynamic> json) {
    return AutocompleteSuggestion(
      keyword: json['keyword'] as String?,
      highlighted: json['highlighted'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'highlighted': highlighted,
    };
  }
}
