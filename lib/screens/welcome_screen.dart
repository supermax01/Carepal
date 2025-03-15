import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              Image.asset(
                'lib/images/Vector.png',
                height: 60,
              ),
              const SizedBox(height: 8),
              const Text(
                'CarePal',
                style: TextStyle(
                  color: Color(0xFF046D54),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Main Image
              Flexible(
                flex: 4,
                child: Image.asset(
                  'lib/images/doctors.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Text Content
              const Text(
                'Cirrhosis Care at your Fingertips!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CarePal helps you manage appointments, track medications, consult with doctors, and monitor symptoms. Enjoy peace of mind, and stay on top of your health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
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
                      'Get Started',
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
}
