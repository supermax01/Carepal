import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys
  static const String _geminiApiKey = 'GEMINI_API_KEY';
  static const String _redcapToken = 'REDCAP_TOKEN';

  // Initialize API keys
  static Future<void> initializeApiKeys() async {
    // Initialize Gemini API key
    final String? existingGeminiKey = await _storage.read(key: _geminiApiKey);
    if (existingGeminiKey == null) {
      final geminiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (geminiKey.isNotEmpty) {
        await _storage.write(key: _geminiApiKey, value: geminiKey);
      }
    }

    // Initialize REDCap token
    final String? existingRedcapToken = await _storage.read(key: _redcapToken);
    if (existingRedcapToken == null) {
      final redcapToken = dotenv.env['REDCAP_TOKEN'] ?? '';
      if (redcapToken.isNotEmpty) {
        await _storage.write(key: _redcapToken, value: redcapToken);
      }
    }
  }

  // Get Gemini API key
  static Future<String?> getGeminiApiKey() async {
    return await _storage.read(key: _geminiApiKey);
  }

  // Update Gemini API key
  static Future<void> updateGeminiApiKey(String newKey) async {
    await _storage.write(key: _geminiApiKey, value: newKey);
  }

  // Get REDCap token
  static Future<String?> getRedcapToken() async {
    return await _storage.read(key: _redcapToken);
  }

  // Update REDCap token
  static Future<void> updateRedcapToken(String newToken) async {
    await _storage.write(key: _redcapToken, value: newToken);
  }

  // Delete all keys (useful for logout/reset)
  static Future<void> deleteAllKeys() async {
    await _storage.deleteAll();
  }
}
