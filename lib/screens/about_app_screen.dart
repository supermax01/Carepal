import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About CarePal',
          style: TextStyle(
            color: Color(0xFF056E55),
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('About CarePal', 
                'CarePal is being designed and developed by MS. Health Informatics student Chandra Vikram at Indiana University Indianapolis under the guidance of Dr. Archita Desai and Dr. Saptarshi Purkayastha. This app is designed to help liver cirrhosis patients manage their health efficiently and provide them with a knowledge resource related to cirrhosis.'
              ),
              _buildSection('Purpose', 
                'CarePal aims to empower liver cirrhosis patients by providing tools for health management and offering valuable information about their condition.'
              ),
              _buildSection('Technologies Used', 
                '• Flutter: UI framework for building natively compiled applications\n'
                '• Dart: Programming language used with Flutter\n'
                '• Google Gemini: AI model used for generating health-related content\n'
                '• Firebase: Backend services for data storage and authentication'
              ),
              _buildSection('Acknowledgements', 
                'We would like to thank the following for their contributions:\n'
                '• Dr. Archita Desai for clinical guidance\n'
                '• Dr. Saptarshi Purkayastha for technical supervision\n'
                '• The Flutter and Dart communities for their excellent documentation and support'
              ),
              _buildSection('Version', 'CarePal v1.0.0'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF056E55),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
