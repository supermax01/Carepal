import 'package:flutter/material.dart';
import 'learn_cirrhosis_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Educational Materials assigned',
      'message': "Dr. Archita has assigned you new educational about ESLD management.",
      'leftButtonText': 'Later',
      'rightButtonText': 'Review',
    },
    {
      'title': 'Healthy Tip',
      'message': "Include oatmeal in your breakfast for a fiber-rich start to your day. It's great for your liver health!",
      'leftButtonText': 'Dismiss',
      'rightButtonText': 'Save',
    },
    {
      'title': '2 tbsp Lactulose',
      'message': "It's time to take your 2 tbsp of Lactulose. Please take your dose now at 8:00 AM.",
      'leftButtonText': 'Remind',
      'rightButtonText': 'Taken',
    },
    {
      'title': 'Drink Water',
      'message': "Drink a glass of water now to stay hydrated. Aim for 8 glasses today to help manage your symptoms better.",
      'leftButtonText': 'Dismiss',
      'rightButtonText': 'Done',
    },
    {
      'title': '10mg Prednisone',
      'message': "It's time to take your 10 mg of Prednisone. Please take your dose now at 8:00 AM.",
      'leftButtonText': 'Remind',
      'rightButtonText': 'Taken',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications and Reminders',
          style: TextStyle(
            color: Color(0xFF1E6C50),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert, color: Color(0xFF1E6C50)),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(
            title: notifications[index]['title'],
            message: notifications[index]['message'],
            leftButtonText: notifications[index]['leftButtonText'],
            rightButtonText: notifications[index]['rightButtonText'],
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    String? leftButtonText,
    String? rightButtonText,
    required int index,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                if (leftButtonText != null && rightButtonText != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () => _handleLeftButtonPress(leftButtonText, index),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            leftButtonText,
                            style: const TextStyle(
                              color: Color(0xFF056E55),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _handleRightButtonPress(rightButtonText, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF056E55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          rightButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLeftButtonPress(String buttonText, int index) {
    if (buttonText == 'Remind') {
      _showReminderDialog(index);
    } else if (buttonText == 'Review Later' || buttonText == 'Later') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You\'ll be reminded later.')),
      );
    } else if (buttonText == 'Dismiss') {
      final removedNotification = notifications.removeAt(index);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notification dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                notifications.insert(index, removedNotification);
              });
            },
          ),
        ),
      );
    }
  }

  void _handleRightButtonPress(String buttonText, int index) {
    if (buttonText == 'Taken' || buttonText == 'Confirm' || buttonText == 'Done') {
      final removedNotification = notifications.removeAt(index);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Excellent work, you are doing great!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                notifications.insert(index, removedNotification);
              });
            },
          ),
        ),
      );
    } else if (buttonText == 'Review') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LearnCirrhosisScreen(
            initialScreen: 'infographics',
          ),
        ),
      );
    } else if (buttonText == 'Learn') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LearnCirrhosisScreen()),
      );
    } else if (buttonText == 'Save') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tip saved for future reference')),
      );
    }
  }

  void _showReminderDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Reminder'),
          content: const Text('When would you like to be reminded?'),
          actions: <Widget>[
            TextButton(
              child: const Text('In 15 minutes'),
              onPressed: () => _setReminder(index, 15),
            ),
            TextButton(
              child: const Text('In 30 minutes'),
              onPressed: () => _setReminder(index, 30),
            ),
            TextButton(
              child: const Text('In 1 hour'),
              onPressed: () => _setReminder(index, 60),
            ),
          ],
        );
      },
    );
  }

  void _setReminder(int index, int minutes) {
    Navigator.of(context).pop();
    // Here you would typically set up an actual reminder using a plugin or service
    // For this example, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set for $minutes minutes from now')),
    );
    // Optionally, you can update the notification to reflect the new reminder time
    setState(() {
      notifications[index]['message'] += '\nReminder set for $minutes minutes from now.';
    });
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String message = '';
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Reminder Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Reminder Message'),
                onChanged: (value) => message = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (title.isNotEmpty && message.isNotEmpty) {
                  setState(() {
                    notifications.add({
                      'title': title,
                      'message': message,
                      'leftButtonText': 'Dismiss',
                      'rightButtonText': 'Done',
                    });
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminder added')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
