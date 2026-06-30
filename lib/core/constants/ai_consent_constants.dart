class AiConsentConstants {
  AiConsentConstants._();

  /// Storage key for the AI consent version accepted by the user.
  ///
  /// Do not reuse the old boolean key because users/reviewers may update
  /// from an older build where that boolean was already true.
  static const String consentVersionStorageKey = 'ai_consent_version_v3';

  /// Current AI consent content version.
  ///
  /// Change this value only when the AI consent content changes materially,
  /// such as:
  /// - adding a new third-party AI provider
  /// - changing what data is sent
  /// - changing who receives the data
  /// - changing the purpose of data processing
  /// - changing AI chat history retention or sharing behavior
  ///
  /// Do not change this value for normal app updates, bug fixes, or UI-only
  /// changes.
  static const String currentConsentVersion = 'ai-consent-2026-06-28-v2';

  /// Legacy boolean key used by older builds.
  ///
  /// This key must not be used to determine whether the user has accepted
  /// the current AI consent version.
  static const String legacyConsentAcceptedKey =
      'ai_chat_data_consent_accepted';

  /// Data recipients shown in the AI consent notice.
  static const String eduTechServer = 'Edu-Tech servers';
  static const String openAiProvider =
      'OpenAI, LLC through the OpenAI API';
  static const String googleGeminiProvider =
      'Google LLC through the Gemini API';

  /// Public Privacy Policy URL.
  static const String privacyPolicyUrl =
      'https://nguyenduc163.notion.site/Privacy-Policy-for-EdTech-38303bc29711802394ade6a5fb8ecee9';
}
