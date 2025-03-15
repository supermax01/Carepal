import 'package:flutter/material.dart';

class Promis29Screen extends StatefulWidget {
  const Promis29Screen({super.key});

  @override
  _Promis29ScreenState createState() => _Promis29ScreenState();
}

class _Promis29ScreenState extends State<Promis29Screen> {
  final Map<String, List<String>> questions = {
    'Physical Function': [
      'Are you able to do chores such as vacuuming or yard work?',
      'Are you able to go up and down stairs at a normal pace?',
      'Are you able to go for a walk of at least 15 minutes?',
      'Are you able to run errands and shop?',
    ],
    'Anxiety': [
      'I felt fearful',
      'I found it hard to focus on anything other than my anxiety',
      'My worries overwhelmed me',
      'I felt uneasy',
    ],
    'Depression': [
      'I felt worthless',
      'I felt helpless',
      'I felt depressed',
      'I felt hopeless',
    ],
    'Fatigue': [
      'I feel fatigued',
      'I have trouble starting things because I am tired',
      'How run-down did you feel on average?',
      'How fatigued were you on average?',
    ],
    'Sleep Disturbance': [
      'My sleep quality was',
      'My sleep was refreshing',
      'I had a problem with my sleep',
      'I had difficulty falling asleep',
    ],
    'Ability to Participate in Social Roles and Activities': [
      'I have trouble doing all of my regular leisure activities with others',
      'I have trouble doing all of the family activities that I want to do',
      'I have trouble doing all of my usual work (include work at home)',
      'I have trouble doing all of the activities with friends that I want to do',
    ],
    'Pain Interference': [
      'How much did pain interfere with your day to day activities?',
      'How much did pain interfere with work around the home?',
      'How much did pain interfere with your ability to participate in social activities?',
      'How much did pain interfere with your household chores?',
    ],
    'Pain Intensity': [
      'How would you rate your pain on average?',
      'What is your level of pain right now?',
    ],
    'Cognitive Function - Abilities': [
      'I have been able to concentrate',
      'My thinking has been slow',
    ],
    'Cognitive Function - Concerns': [
      'I have had to work harder than usual to keep track of what I was doing',
      'I have had trouble shifting back and forth between different activities that require thinking',
    ],
  };

  final Map<String, List<int?>> responses = {};

  @override
  void initState() {
    super.initState();
    for (var domain in questions.keys) {
      responses[domain] = List.filled(questions[domain]!.length, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'PROMIS-29+2',
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
              ...questions.entries
                  .map((entry) => _buildDomainSection(entry.key, entry.value)),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.35, // 35% of screen width
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF056E55),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // More rounded corners
                      ),
                      elevation: 2, // Add a slight shadow
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDomainSection(String domain, List<String> domainQuestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            domain,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ...domainQuestions.asMap().entries.map((entry) {
          int index = entry.key;
          String question = entry.value;
          return _buildQuestionItem(domain, index, question);
        }),
      ],
    );
  }

  Widget _buildQuestionItem(String domain, int index, String question) {
    List<String> options = domain == 'Pain Intensity'
        ? ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
        : [
            'Not at all',
            'A little bit',
            'Somewhat',
            'Quite a bit',
            'Very much'
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        ...options.asMap().entries.map((option) {
          return RadioListTile<int>(
            title: Text(option.value),
            value: option.key,
            groupValue: responses[domain]![index],
            onChanged: (int? value) {
              setState(() {
                responses[domain]![index] = value;
              });
            },
            activeColor: const Color(0xFF056E55),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitForm() {
    // TODO: Implement actual form submission logic here
    // For now, we'll just show a success message

    // Close the keyboard if it's open
    FocusScope.of(context).unfocus();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Your submission has been recorded successfully',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color(0xFF056E55),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Optional: Navigate back to previous screen after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }
}
