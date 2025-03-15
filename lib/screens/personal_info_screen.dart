import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Personal Information',
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
                'View your personal information right here.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoField('First Name'),
              _buildInfoField('Last Name'),
              _buildInfoField('Middle Name'),
              _buildInfoField('Preferred Name'),
              _buildInfoField('Gender'),
              _buildInfoField('Date of Birth'),
              _buildInfoField('Marital Status'),
              _buildInfoField('Language'),
              _buildInfoField('Race'),
              _buildInfoField('Ethnicity'),
              _buildInfoField('Address'),
              Row(
                children: [
                  Expanded(child: _buildInfoField('City')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInfoField('State')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInfoField('Zipcode')),
                ],
              ),
              _buildInfoField('Country'),
              _buildInfoField('Email'),
              _buildInfoField('Phone number'),
              _buildInfoField('Work Phone'),
              _buildInfoField('Emergency Contact Name'),
              _buildInfoField('Emergency Contact Phone'),
              _buildInfoField('Relationship to Emergency Contact'),
              _buildInfoField('Primary Care Provider'),
              _buildInfoField('Insurance Provider'),
              _buildInfoField('Insurance ID'),
              _buildInfoField('Social Security Number (last 4 digits)'),
              _buildInfoField('Occupation'),
              _buildInfoField('Employer'),
              _buildInfoField('Blood Type'),
              _buildInfoField('Allergies'),
              _buildInfoField('Immunizations'),
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
