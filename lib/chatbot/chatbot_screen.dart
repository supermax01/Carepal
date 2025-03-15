import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'message_model.dart';
import 'chat_message_widget.dart';
import 'chat_history_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ChatbotScreenState createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen>
    with AutomaticKeepAliveClientMixin {
  final ChatbotService _chatbotService = ChatbotService();
  static final List<Message> _messages =
      []; // Make messages static to persist across rebuilds
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Box<List<dynamic>>? _chatHistoryBox;
  bool _isSending = false;

  @override
  bool get wantKeepAlive => true; // Keep the state alive when navigating

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Static method to restore a previous conversation
  static Future<void> restoreConversation(List<Message> oldConversation) async {
    try {
      // If there's an active conversation, save it first
      if (_messages.isNotEmpty) {
        final box = Hive.box<List<dynamic>>('chatHistory');
        await saveCurrentSession(box);
      }

      // Clear current messages and add the old conversation
      _messages.clear();
      _messages.addAll(oldConversation);
    } catch (e) {
      print('Error restoring conversation: $e');
    }
  }

  // This will be called when the app is being terminated or when switching conversations
  static Future<void> saveCurrentSession(Box<List<dynamic>> box) async {
    if (_messages.isEmpty) return;

    try {
      final List<Map<String, dynamic>> currentSession = _messages
          .where((msg) => msg.text.isNotEmpty)
          .map((msg) => {
                'text': msg.text,
                'isUser': msg.isUser,
                'timestamp': msg.timestamp.toIso8601String(),
                'isThinking': msg.isThinking,
              })
          .toList();

      if (currentSession.isNotEmpty) {
        await box.add(currentSession);
      }
    } catch (e) {
      print('Error saving current session: $e');
    }
  }

  Future<void> _initializeChat() async {
    try {
      if (!Hive.isBoxOpen('chatHistory')) {
        _chatHistoryBox = await Hive.openBox<List<dynamic>>('chatHistory');
      } else {
        _chatHistoryBox = Hive.box<List<dynamic>>('chatHistory');
      }

      if (_messages.isEmpty) {
        _addBotMessage(
            "Hi, I'm Vik. I'm here to help you with liver cirrhosis management. What would you like to know?");
      }
    } catch (e) {
      print('Error initializing chat: $e');
      if (_messages.isEmpty) {
        _addBotMessage(
            "Hi, I'm Vik. I'm here to help you with liver cirrhosis management. What would you like to know?");
      }
    }
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
              return Message(
                text: item['text']?.toString() ?? '',
                isUser: item['isUser'] as bool? ?? false,
                timestamp: item['timestamp'] != null
                    ? DateTime.parse(item['timestamp'].toString())
                    : DateTime.now(),
                isThinking: item['isThinking'] as bool? ?? false,
              );
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () {
            FocusScope.of(context).unfocus();
          },
        ),
        title: const Text(
          'How can I help you?',
          style: TextStyle(
              color: Color(0xFF056E55),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatHistoryScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Chat History'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: 'history',
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(message: _messages[index]);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !_isSending,
              textInputAction: TextInputAction.send,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: _isSending ? 'Sending...' : 'Ask me anything...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: _isSending ? Colors.grey : const Color(0xFF056E55),
            child: IconButton(
              icon: Icon(
                _isSending ? Icons.hourglass_empty : Icons.send,
                color: Colors.white,
              ),
              onPressed: _isSending
                  ? null
                  : () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    text = text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _textController.clear();
    _addUserMessage(text);

    try {
      setState(() {
        _messages.add(Message(
          text: "...",
          isUser: false,
          isThinking: true,
        ));
      });
      _scrollToBottom();

      final response = await _chatbotService.sendMessage(text);

      setState(() {
        if (_messages.isNotEmpty && _messages.last.isThinking) {
          _messages.removeLast();
        }
        _addBotMessage(response);
      });
    } catch (e) {
      setState(() {
        if (_messages.isNotEmpty && _messages.last.isThinking) {
          _messages.removeLast();
        }
        _addBotMessage("I couldn't process that request. Let's try again?");
      });
      _showError("Connection issue. Please check your internet and try again.");
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _addUserMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _testHiveStorage() async {
    try {
      final box = Hive.box<List<Message>>('chatHistory');

      // Test message
      final testMessage = Message(
        text: "Test message",
        isUser: true,
      );

      // Store test message
      await box.add([testMessage]);

      // Retrieve and verify
      final retrieved = box.getAt(box.length - 1) as List<Message>;
      print('Hive Test - Stored message: ${retrieved.first.text}');
    } catch (e) {
      print('Hive Test Error: $e');
    }
  }

  Future<void> _loadLastConversation() async {
    if (_chatHistoryBox == null || !_chatHistoryBox!.isOpen) return;

    try {
      if (_chatHistoryBox!.isNotEmpty) {
        final lastConversation =
            _chatHistoryBox!.getAt(_chatHistoryBox!.length - 1);
        if (lastConversation != null) {
          final messages = _convertToMessageList(lastConversation);
          if (messages.isNotEmpty) {
            setState(() {
              _messages.clear();
              _messages.addAll(messages);
            });
          }
        }
      }
    } catch (e) {
      print('Error loading last conversation: $e');
    }
  }
}
