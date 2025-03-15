import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chatbot/message_model.dart';
import 'models/user_credentials.dart';
import 'config/env.dart';
import 'chatbot/chatbot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment
  await Environment.initialize();

  try {
    await Hive.initFlutter();

    // Register Hive Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MessageAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserCredentialsAdapter());
    }

    // Initialize boxes
    final chatHistoryBox = await Hive.openBox<List<dynamic>>('chatHistory');
    await Hive.openBox<UserCredentials>('userCredentials');

    print('Hive initialized successfully');

    runApp(MyApp(chatHistoryBox: chatHistoryBox));
  } catch (e) {
    print('Error initializing Hive: $e');
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  final Box<List<dynamic>>? chatHistoryBox;

  const MyApp({super.key, this.chatHistoryBox});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App is being closed or terminated
      if (widget.chatHistoryBox != null) {
        ChatbotScreenState.saveCurrentSession(widget.chatHistoryBox!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Starting app with WelcomeScreen');
    return MaterialApp(
      title: 'CarePal App',
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF056E55),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
