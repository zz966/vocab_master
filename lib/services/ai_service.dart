/// Placeholder for future Grok API integration to generate example sentences.
///
/// MVP+: wire [generateExamples] to your Grok endpoint when ready.
class AiService {
  AiService._();

  static final AiService instance = AiService._();

  bool get isAvailable => false;

  /// Generates example sentences for [english] / [chinese].
  ///
  /// Returns `null` when AI is not configured (MVP placeholder).
  Future<List<String>?> generateExamples({
    required String english,
    required String chinese,
    String? partOfSpeech,
  }) async {
    // TODO: Connect Grok API — POST with word context, parse examples array.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return null;
  }
}