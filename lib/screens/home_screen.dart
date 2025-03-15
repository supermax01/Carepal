import 'package:flutter/material.dart';
import 'progress_screen.dart';
import 'medications_screen.dart';
import 'appointments_screen.dart';
import 'learn_cirrhosis_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 36),
                _buildInfoCard('Your Progress', 'lib/images/progress.png', context),
                const SizedBox(height: 36),
                _buildInfoCard('Your Medications', 'lib/images/medications.png', context),
                const SizedBox(height: 36),
                _buildInfoCard('Your Appointments', 'lib/images/dates.png', context),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LearnCirrhosisScreen(),
                      ),
                    );
                  },
                  child: _buildInfoCard(
                    'Cirrhosis Resources',
                    'lib/images/knowledge.png',
                    context,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Good Morning, Jessica!' ,
            style: TextStyle(
              color: Color(0xFF056E55),
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('lib/images/profile_picture.png'),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String imagePath, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 155,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x99056E55)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath, width: 128, height: 123),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.15,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _getScreenForTitle(title),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF056E55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        child: const Text(
                          'Take me there',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getScreenForTitle(String title) {
    switch (title) {
      case 'Your Progress':
        return const ProgressScreen();
      case 'Your Medications':
        return const MedicationsScreen();
      case 'Your Appointments':
        return const AppointmentsScreen();
      case 'Cirrhosis Resources':
        return const LearnCirrhosisScreen();
      default:
        return const Scaffold(body: Center(child: Text('Screen not found')));
    }
  }
}
