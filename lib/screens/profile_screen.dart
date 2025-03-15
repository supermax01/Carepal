import 'package:flutter/material.dart';
import 'personal_info_screen.dart';
import 'hospital_info_screen.dart';
import 'app_settings_screen.dart';
import 'about_app_screen.dart';
import 'health_report_screen.dart';
import '../redcap/screens/promis_forms_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 48),
                _buildProfileOption(
                  'Your Information',
                  'Find personal information here.',
                  'lib/images/personal_info.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalInfoScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  'Hospital Info',
                  'Information about the hospital.',
                  'lib/images/hospital_info.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HospitalInfoScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  'App Settings',
                  'Change the application settings.',
                  'lib/images/app_settings.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppSettingsScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  'Health Report',
                  'View your Lab reports here.',
                  'lib/images/health_report.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HealthReportScreen()),
                    );
                  },
                ),
                _buildProfileOption(
                  'PROMIS Forms',
                  'Complete your PROMIS assessments',
                  'lib/images/lc_prom.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PromisFormsScreen(
                          recordId: 'RECORD_ID', // TODO: Get actual record ID
                        ),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  'About the app',
                  'Details of the app version.',
                  'lib/images/about_app.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutAppScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('lib/images/profile_picture.png'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Robert Kwiosky',
          style: TextStyle(
            color: Color(0xFF056E55),
            fontSize: 23,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Edit your profile and other settings.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
      String title, String subtitle, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0x991AA282)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 128,
              height: 96,
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.87),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 0.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
