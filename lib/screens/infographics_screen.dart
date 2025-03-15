import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfographicsScreen extends StatelessWidget {
  const InfographicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cirrhosis Infographics',
          style: TextStyle(color: Color(0xFF056E55)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(context, 'What the Liver Does', Colors.grey,
              'https://cirrhosiscare.ca/patients/cirrhosis/what-the-liver-does/'),
          _buildInfoCard(context, 'What is Cirrhosis?', Colors.grey,
              'https://cirrhosiscare.ca/patients/cirrhosis/what-is-cirrhosis/'),
          _buildInfoCard(context, 'What is Portal Hypertension?', Colors.grey,
              'https://cirrhosiscare.ca/patients/cirrhosis/diagnosis/'),
          _buildInfoCard(context, 'Stages of Cirrhosis', Colors.grey,
              'https://cirrhosiscare.ca/stages-of-cirrhosis/'),
          _buildInfoCard(context, 'Living with Cirrhosis', Colors.grey,
              'https://cirrhosiscare.ca/health-monitoring-patient/'),
          _buildInfoCard(context, 'When to Go to Emergency', Colors.grey,
              'https://cirrhosiscare.ca/when-to-go-to-emergency/'),
          _buildInfoCard(context, 'Core Patient Education', Colors.grey,
              'https://cirrhosiscare.ca/discharge-videos/'),
          _buildInfoCard(context, 'Common Terms', Colors.grey,
              'https://cirrhosiscare.ca/patients/cirrhosis/common-terms/'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, Color color, String url) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              if (url.isNotEmpty) {
                _launchURL(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Content for "$title" is not available yet.')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF056E55)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
