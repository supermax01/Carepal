import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final bool isThinking;

  Message({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.isThinking = false,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert Message to Map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isThinking': isThinking,
    };
  }

  // Create Message from Map
  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] as String? ?? '',
      isUser: map['isUser'] as bool? ?? false,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : null,
      isThinking: map['isThinking'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'Message(text: $text, isUser: $isUser, timestamp: $timestamp, isThinking: $isThinking)';
  }
}
