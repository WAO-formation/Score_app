import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Firebase Auth persists a signed-in session on-device indefinitely on its
/// own — without something bounding it, "signed in" means "signed in
/// forever." This layers an expiring window on top, tracked in secure
/// storage (not SharedPreferences, since it's effectively a session
/// credential): "Remember me" gets a long window, otherwise a short one, so
/// a casual or shared-device sign-in doesn't stay valid indefinitely.
class SessionService {
  SessionService._();

  static const _storage = FlutterSecureStorage();
  static const _expiryKey = 'wao_session_expiry';

  static const Duration rememberedDuration = Duration(days: 30);
  static const Duration defaultDuration = Duration(days: 1);

  /// Call right after a successful sign-in.
  static Future<void> recordLogin({required bool rememberMe}) async {
    final expiry = DateTime.now().add(rememberMe ? rememberedDuration : defaultDuration);
    await _storage.write(key: _expiryKey, value: expiry.toIso8601String());
  }

  /// True while the window is still open. A *missing* record — someone
  /// already signed in from before this existed, so login() never ran for
  /// them — is treated as "start a fresh default window now" rather than an
  /// immediate forced sign-out; a record that's present but elapsed is a
  /// real expiry and returns false.
  static Future<bool> isSessionValid() async {
    final raw = await _storage.read(key: _expiryKey);
    if (raw == null) {
      await recordLogin(rememberMe: false);
      return true;
    }
    final expiry = DateTime.tryParse(raw);
    if (expiry == null) return false;
    return DateTime.now().isBefore(expiry);
  }

  /// Call on sign-out (including an expired-session auto sign-out) so a
  /// stale expiry can't leak into whoever signs in next on this device.
  static Future<void> clearSession() async {
    await _storage.delete(key: _expiryKey);
  }
}
