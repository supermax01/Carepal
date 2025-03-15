import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'message_model.dart';
import 'chat_message_widget.dart';
import 'chatbot_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late Box<List<dynamic>> _chatHistoryBox;

  @override
  void initState() {
    super.initState();
    _chatHistoryBox = Hive.box<List<dynamic>>('chathistory');
  }

  @override
  void dispose() {
    if (_chatHistoryBox.isOpen) {
      _chatHistoryBox.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildChatHistory(),
    );
  }

  Widget _buildChatHistory() {
    if (_chatHistoryBox.isEmpty) {
      return const Center(
        child: Text('No chat history available'),
      );
    }

    return ListView.builder(
      itemCount: _chatHistoryBox.length,
      itemBuilder: (context, index) {
        final reversedIndex = _chatHistoryBox.length - 1 - index;
        final conversation =
            _convertToMessageList(_chatHistoryBox.getAt(reversedIndex));

        if (conversation.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(
              _getConversationPreview(conversation),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(_formatDate(conversation.first.timestamp)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationDetailScreen(
                    conversation: conversation,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getConversationPreview(List<Message> conversation) {
    final firstUserMessage = conversation.firstWhere(
      (message) => message.isUser,
      orElse: () => conversation.first,
    );
    return firstUserMessage.text;
  }

  List<Message> _convertToMessageList(dynamic data) {
    if (data is! List) {
      print('Data is not a List: $data');
      return [];
    }

    return data
        .map<Message>((item) {
          try {
            // Handle Map<dynamic, dynamic>
            if (item is Map) {
              final message = Message(
                text: item['text']?.toString() ?? '',
                isUser: item['isUser'] as bool? ?? false,
                timestamp: item['timestamp'] != null
                    ? DateTime.parse(item['timestamp'].toString())
                    : DateTime.now(),
                isThinking: item['isThinking'] as bool? ?? false,
              );
              return message;
            }
            print('Unhandled data type: ${item.runtimeType} - $item');
            return Message(text: '', isUser: false);
          } catch (e) {
            print('Error converting message: $e');
            return Message(text: '', isUser: false);
          }
        })
        .where((message) => message.text.isNotEmpty)
        .toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}

class ConversationDetailScreen extends StatelessWidget {
  final List<Message> conversation;

  const ConversationDetailScreen({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation Details'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Restore Conversation'),
                  content: const Text(
                    'Do you want to continue this conversation? This will save your current chat and restore this conversation.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ChatbotScreenState.restoreConversation(conversation);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close detail screen
                        Navigator.pop(context); // Return to chat screen
                      },
                      child: const Text('Continue This Chat'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Continue This Chat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: conversation.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final message = conversation[index];
          return ChatMessageWidget(message: message);
        },
      ),
    );
  }
}
