
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


  static String resolve(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null || !_allowedHosts.contains(uri.host)) return url;

    final id = _extractFileId(url);
    if (id == null) return url;


    return 'https://lh3.googleusercontent.com/d/$id=w1000';
  }


  static bool isSafeToLoad(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }
}
