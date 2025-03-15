import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/secure_storage_service.dart';

class Environment {
  // Secure storage getters
  static Future<String> get geminiApiKey async {
    final secureKey = await SecureStorageService.getGeminiApiKey();
    if (secureKey != null) return secureKey;

    // Fallback to .env if secure storage is empty (first run)
    final envKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (envKey.isNotEmpty) {
      await SecureStorageService.updateGeminiApiKey(envKey);
    }
    return envKey;
  }

  static Future<String> get redcapApiKey async {
    final secureKey = await SecureStorageService.getRedcapToken();
    if (secureKey != null) return secureKey;

    // Fallback to .env if secure storage is empty (first run)
    final envKey = dotenv.env['REDCAP_TOKEN'] ?? '';
    if (envKey.isNotEmpty) {
      await SecureStorageService.updateRedcapToken(envKey);
    }
    return envKey;
  }

  // Environment configuration from .env
  static String get appEnvironment => dotenv.env['APP_ENV'] ?? 'development';
  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'https://api.carepal.dev';
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static String get redcapUrl => dotenv.env['REDCAP_URL'] ?? '';
  static String get redcapApiUrl =>
      dotenv.env['REDCAP_API_URL'] ?? 'https://redcap.uits.iu.edu/api/';

  // App configuration from .env
  static int get cacheDuration =>
      int.tryParse(dotenv.env['CACHE_DURATION'] ?? '') ?? 3600;
  static int get maxRetryAttempts =>
      int.tryParse(dotenv.env['MAX_RETRY_ATTEMPTS'] ?? '') ?? 3;

  // Initialize environment
  static Future<void> initialize() async {
    // Load .env file
    await dotenv.load();

    // Initialize secure storage with values from .env
    await SecureStorageService.initializeApiKeys();
  }

  // Add other environment variables here
}
