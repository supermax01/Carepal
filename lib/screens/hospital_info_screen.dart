import 'package:flutter/material.dart';

class HospitalInfoScreen extends StatelessWidget {
  const HospitalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Hospital Information',
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
              const Text(
                'View information about your healthcare provider.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoField('Provider Name'),
              _buildInfoField('Provider ID'),
              _buildInfoField('NPI Number'),
              _buildInfoField('Specialty'),
              _buildInfoField('Organization'),
              _buildInfoField('Address'),
              _buildInfoField('City'),
              _buildInfoField('State'),
              _buildInfoField('Zip Code'),
              _buildInfoField('Phone Number'),
              _buildInfoField('Email'),
              _buildInfoField('Website'),
              _buildInfoField('License Number'),
              _buildInfoField('Certification'),
              _buildInfoField('Languages Spoken'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
