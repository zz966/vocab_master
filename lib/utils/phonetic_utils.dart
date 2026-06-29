String formatPhonetic(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return '';
  }
  if (trimmed.startsWith('/') || trimmed.startsWith('[')) {
    return trimmed;
  }
  return '/$trimmed/';
}

String resolvePhoneticUk({
  required String phoneticUk,
  required String phoneticUs,
}) {
  if (phoneticUk.trim().isNotEmpty) {
    return formatPhonetic(phoneticUk);
  }
  if (phoneticUs.trim().isNotEmpty) {
    return formatPhonetic(phoneticUs);
  }
  return '';
}

String resolvePhoneticUs({
  required String phoneticUk,
  required String phoneticUs,
}) {
  if (phoneticUs.trim().isNotEmpty) {
    return formatPhonetic(phoneticUs);
  }
  if (phoneticUk.trim().isNotEmpty) {
    return formatPhonetic(phoneticUk);
  }
  return '';
}