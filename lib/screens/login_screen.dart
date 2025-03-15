import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_credentials.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final box = await Hive.openBox<UserCredentials>('userCredentials');
      if (box.isNotEmpty) {
        final credentials = box.getAt(0);
        if (credentials != null) {
          setState(() {
            _emailController.text = credentials.email;
            _passwordController.text = credentials.password;
            _rememberMe = true;
          });
        }
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final box = await Hive.openBox<UserCredentials>('userCredentials');
      if (_rememberMe) {
        await box.put(
            'credentials',
            UserCredentials(
              email: _emailController.text,
              password: _passwordController.text,
            ));
        print('Credentials saved successfully');
      } else {
        await box.clear();
        print('Credentials cleared');
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  Future<bool> _showSaveCredentialsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Login'),
          content: const Text('Would you like to save your login credentials?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Logo and Title
              Image.asset('lib/images/Vector.png', height: 60),
              const SizedBox(height: 8),
              const Text(
                'CarePal',
                style: TextStyle(
                  color: Color(0xFF056E55),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 1),

              // Welcome Text and Image
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                flex: 4,
                child: Image.asset(
                  'lib/images/loginpic.png',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 1),

              // Input Fields
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter your Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Login Button
              GestureDetector(
                onTap: () async {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    final shouldSave = await _showSaveCredentialsDialog();
                    if (shouldSave) {
                      _rememberMe = true;
                      await _saveCredentials();
                    }
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF056E55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
