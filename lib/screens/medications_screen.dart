import 'package:flutter/material.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Medications',
          style: TextStyle(
            color: Color(0xFF056E55),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/profile_picture.png'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(
              padding: EdgeInsets.all(constraints.maxWidth * 0.04),
              children: [
                _buildMedicationCard(context, constraints, 'Propranolol', [
                  'Dosage: 40mg',
                  'Frequency: Twice daily.',
                  'Reminder: Set for 8AM and 8PM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Vitamin K', [
                  'Updated: Vitamin D3',
                  'Dosage: 1000 IU.',
                  'Frequency: Once daily to support bone health.',
                  'Reminder: Set at 10AM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Lactulose', [
                  'Dosage: 30ml',
                  'Frequency: Thrice daily.',
                  'Reminder: Set for 7AM, 3PM and 11PM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Rifaximin', [
                  'Dosage: 550mg',
                  'Frequency: Twice daily.',
                  'Reminder: Set for 7AM and 7PM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Spironolactone', [
                  'Dosage: 100mg',
                  'Frequency: Once daily.',
                  'Reminder: Set for 9AM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Furosemide', [
                  'Dosage: 40mg',
                  'Frequency: Once daily.',
                  'Reminder: Set for 8AM daily.',
                ]),
                _buildMedicationCard(context, constraints, 'Thiamine', [
                  'Dosage: 100mg',
                  'Frequency: Once daily.',
                  'Reminder: Set for 9AM daily.',
                ]),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, BoxConstraints constraints,
      String title, List<String> details) {
    double fontSize = constraints.maxWidth * 0.04;
    return Card(
      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(constraints.maxWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Softer black color
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                  ...details
                      .map((detail) => Padding(
                            padding: EdgeInsets.only(
                                bottom: constraints.maxHeight * 0.005),
                            child: Text(
                              detail, // Removed the bullet point
                              style: TextStyle(fontSize: fontSize),
                            ),
                          ))
                      ,
                ],
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.04),
            GestureDetector(
              onTap: () => _showReminderDialog(context, title),
              child: Icon(
                Icons.access_time,
                color: const Color(0xFF2E8B57),
                size: fontSize * 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog(BuildContext context, String medicationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Reminder'),
          content: Text('Set a reminder for $medicationName'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reminder set for $medicationName')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
