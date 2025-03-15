import 'package:flutter/material.dart';

class HealthReportScreen extends StatelessWidget {
  const HealthReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Health Reports',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Diagnostic Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _buildReportCard(context, 'Blood Reports', Icons.opacity, 'View your latest blood test results'),
            _buildReportCard(context, 'Imaging Reports', Icons.image, 'Access your X-rays, CT scans, and MRIs'),
            _buildReportCard(context, 'Liver Function Tests', Icons.science, 'Check your liver enzyme levels and other liver function indicators'),
            _buildReportCard(context, 'Endoscopy Reports', Icons.camera, 'View results from your upper endoscopy or colonoscopy'),
            _buildReportCard(context, 'Biopsy Results', Icons.biotech, 'Access your liver biopsy results'),
            _buildReportCard(context, 'Ultrasound Reports', Icons.waves, 'Check your abdominal ultrasound results'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, IconData icon, String description) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0x991AA282), width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to specific report screen
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF056E55).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF056E55),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF056E55), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
