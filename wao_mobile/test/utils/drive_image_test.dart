import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/core/utils/drive_image.dart';

void main() {
  group('DriveImage.resolve', () {
    test('converts a /file/d/{id}/view share link to a direct lh3 image URL', () {
      final resolved = DriveImage.resolve('https://drive.google.com/file/d/1AbCdEfGhIjKlMnOp/view?usp=sharing');
      expect(resolved, 'https://lh3.googleusercontent.com/d/1AbCdEfGhIjKlMnOp=w1000');
    });

    test('converts a short /d/{id} link', () {
      final resolved = DriveImage.resolve('https://drive.google.com/d/1AbCdEfGhIjKlMnOp');
      expect(resolved, 'https://lh3.googleusercontent.com/d/1AbCdEfGhIjKlMnOp=w1000');
    });

    test('converts a ?id={id} query-param link', () {
      final resolved = DriveImage.resolve('https://drive.google.com/open?id=1AbCdEfGhIjKlMnOp');
      expect(resolved, 'https://lh3.googleusercontent.com/d/1AbCdEfGhIjKlMnOp=w1000');
    });

    test('leaves an already-resolved lh3.googleusercontent.com URL as-is when no id pattern matches', () {
      const url = 'https://lh3.googleusercontent.com/d/1AbCdEfGhIjKlMnOp=w1000';
      expect(DriveImage.resolve(url), url);
    });

    test('leaves a URL from a host outside the allowlist untouched (does not resolve arbitrary hosts)', () {
      const url = 'https://evil.example.com/file/d/1AbCdEfGhIjKlMnOp/view';
      expect(DriveImage.resolve(url), url);
    });

    test('returns the input unchanged for an empty string', () {
      expect(DriveImage.resolve(''), '');
    });

    test('returns the original URL when the host is allowed but no file id can be extracted', () {
      const url = 'https://drive.google.com/drive/folders/some-folder';
      expect(DriveImage.resolve(url), url);
    });
  });

  group('DriveImage.isSafeToLoad', () {
    test('accepts http and https URLs with a non-empty host', () {
      expect(DriveImage.isSafeToLoad('https://lh3.googleusercontent.com/d/abc=w1000'), isTrue);
      expect(DriveImage.isSafeToLoad('http://example.com/image.png'), isTrue);
    });

    test('rejects a javascript: URL', () {
      expect(DriveImage.isSafeToLoad('javascript:alert(1)'), isFalse);
    });

    test('rejects a data: URL (no host)', () {
      expect(DriveImage.isSafeToLoad('data:text/html,<script>alert(1)</script>'), isFalse);
    });

    test('rejects an empty string', () {
      expect(DriveImage.isSafeToLoad(''), isFalse);
    });

    test('rejects a malformed URL', () {
      expect(DriveImage.isSafeToLoad('not a url at all'), isFalse);
    });
  });
}
