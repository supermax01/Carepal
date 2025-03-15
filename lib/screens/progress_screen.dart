import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Map<String, dynamic>> progressItems = [
    {
      'message':
          'Great job! You\'ve taken 100% of your medications this week. Keep up the perfect streak!',
      'icon': Icons.medication
    },
    {
      'message':
          'You\'re almost there! You\'ve reached 75% of your daily hydration goal. Just two more glasses to go!',
      'icon': Icons.water_drop
    },
    {
      'message':
          'Excellent! You\'ve completed your daily exercise routine. Your cardiovascular health is improving!',
      'icon': Icons.directions_run
    },
    {
      'message':
          'You\'ve logged your meals consistently for a week. Great job tracking your nutrition!',
      'icon': Icons.restaurant_menu
    },
    {
      'message':
          'Your sleep pattern has improved! You\'ve maintained a consistent sleep schedule for 5 days.',
      'icon': Icons.bedtime
    },
    {
      'message':
          'Congratulations! You\'ve reduced your sodium intake by 20% this week. Your liver will thank you!',
      'icon': Icons.restaurant_menu
    },
    {
      'message':
          'You\'ve attended all your scheduled doctor appointments this month. Stay proactive!',
      'icon': Icons.calendar_today
    },
    {
      'message':
          'Your stress levels have decreased by 15% according to your daily mood logs. Keep up the good work!',
      'icon': Icons.spa
    },
    {
      'message':
          'You\'ve successfully avoided alcohol for 30 days straight. Your liver function is improving!',
      'icon': Icons.no_drinks
    },
    {
      'message':
          'Great progress on weight management! You\'ve maintained a healthy weight for 2 weeks.',
      'icon': Icons.monitor_weight
    },
    {
      'message':
          'You\'ve been consistently taking your vitamin supplements. Your nutrient levels are improving!',
      'icon': Icons.medication
    },
    {
      'message':
          'Your latest liver function tests show improvement. Keep following your treatment plan!',
      'icon': Icons.trending_up
    },
    {
      'message':
          'You\'ve reached your protein intake goal for the week. Great job on maintaining muscle mass!',
      'icon': Icons.restaurant_menu
    },
    {
      'message':
          'Your blood pressure readings have been stable for the past two weeks. Excellent progress!',
      'icon': Icons.favorite
    },
    {
      'message':
          'You\'ve successfully managed your ascites symptoms this month. Keep up the good work!',
      'icon': Icons.healing
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Progress',
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
            return ListView.builder(
              padding: EdgeInsets.all(
                  constraints.maxWidth * 0.04), // Responsive padding
              itemCount: progressItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(progressItems[index]['message']),
                  onDismissed: (direction) {
                    final removedItem = progressItems[index];
                    setState(() {
                      progressItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Progress card removed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              progressItems.insert(index, removedItem);
                            });
                          },
                        ),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: _buildProgressCard(
                    progressItems[index]['message'],
                    progressItems[index]['icon'],
                    constraints,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressCard(
      String message, IconData icon, BoxConstraints constraints) {
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
              child: Text(
                message,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.04),
            Column(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF2E8B57),
                  size: fontSize * 1.5,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
