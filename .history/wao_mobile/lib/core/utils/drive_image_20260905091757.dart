
class DriveImage {
  DriveImage._();

  static const _allowedHosts = {
    'drive.google.com',
    'lh3.googleusercontent.com',
    'docs.google.com',
  };


  static final _idPatterns = [
    RegExp(r'/file/d/([a-zA-Z0-9_-]{10,})'),
    RegExp(r'/d/([a-zA-Z0-9_-]{10,})'),
    RegExp(r'[?&]id=([a-zA-Z0-9_-]{10,})'),
  ];

  static String? _extractFileId(String url) {
    for (final pattern in _idPatterns) {
      final match = pattern.firstMatch(url);
      if (match != null) return match.group(1);
    }
    return null;
  }

  /// Normalizes a Drive share/view link into a directly-renderable image
  /// URL. Anything that isn't a recognizable Drive link — including a
  /// plain https image URL from elsewhere — is returned unchanged.
  static String resolve(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null || !_allowedHosts.contains(uri.host)) return url;

    final id = _extractFileId(url);
    if (id == null) return url;

    // Serves any file shared as "Anyone with the link" without Google's
    // increasingly-throttled uc?export=view endpoint.
    return 'https://lh3.googleusercontent.com/d/$id=w1000';
  }

  /// True only for a well-formed http(s) URL — guards against a stray
  /// non-image scheme (e.g. a pasted "javascript:" or "file:" string) ever
  /// reaching Image.network.
  static bool isSafeToLoad(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }
}
