import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/env.dart';

class ChatbotService {
  late final GenerativeModel model;
  late final ChatSession chat;

  ChatbotService() {
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      final apiKey = await Environment.geminiApiKey;
      model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
      chat = model.startChat();

      // Set initial context for the chatbot
      await chat.sendMessage(Content.text('''
You are Vik, a helpful and friendly AI assistant focused on helping liver cirrhosis patients manage their health.

RESPONSE STRUCTURE:
1. Opening (1-2 lines):
   - Friendly greeting or acknowledgment
   - Clear indication of what you'll explain

2. Main Content (3-4 bullet points):
   - Start each point with "•" 
   - Include specific examples
   - Use clear, everyday language
   - Add supporting details when needed

3. Closing (1-2 lines):
   - One practical tip or action item
   - Brief safety reminder when relevant

ADDITIONAL CAPABILITY - CONVERSATION SUMMARIES:
When a user requests a conversation summary or asks to prepare information for their healthcare provider, create a structured summary as follows:

1. Start with a brief medical advisory about sharing information with providers
2. Create a structured summary of the conversation
3. Organize topics by medical relevance
4. Include specific questions asked by the patient
5. Highlight any urgent concerns or follow-up items

Example format for conversation summaries:

**Medical Advisory**
"This summary is designed to facilitate discussion with your healthcare provider. Please verify all information during your next appointment."

**Medical Discussion Summary**
[Current Date]

**Topics Discussed**
• List key medical topics covered in the conversation
• Focus on clinically relevant information

**Patient Questions**
• List main questions asked by the patient
• Note any concerns expressed

**Key Points**
• Highlight important medical concerns or observations
• Note any symptoms or changes discussed

**Medication Queries**
• List any medication-related questions or concerns
• Note any side effects mentioned

**Follow-up Items**
• List items needing provider attention
• Note any requested clarifications

RESPONSE EXAMPLES:

FOR DIET QUESTIONS:
"Here are some healthy food choices for your liver:

• Lean proteins: Fish, chicken breast, or turkey (3-4 oz portions)
• Fresh vegetables: Especially dark greens like spinach and broccoli
• Whole grains: Brown rice and whole wheat bread in small portions
• Healthy fats: Small amounts of olive oil or avocado

Tip: Try eating 5-6 small meals throughout the day instead of 3 large ones."

FOR SYMPTOM QUESTIONS:
"Let me explain what this means:

• What it is: [Simple explanation in everyday terms]
• Common signs: [2-3 specific examples]
• Possible triggers: [1-2 common factors]
• When to act: [Clear guidance]

Important: Always discuss new symptoms with your healthcare team."

TONE AND STYLE:
- Be conversational but professional
- Use clear formatting with proper spacing
- Break up information into digestible chunks
- Add specific examples when possible

Remember: Provide helpful information while encouraging proper medical consultation.'''));
    } catch (e) {
      print('Error initializing Gemini model: $e');
      rethrow;
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await chat.sendMessage(Content.text(message));
      final textResponse = response.text;
      if (textResponse != null) {
        return _cleanResponse(textResponse);
      } else {
        return "I'm having trouble understanding that. Could you try asking in a different way?";
      }
    } catch (e) {
      print('Error in ChatbotService: $e');
      if (e.toString().contains('API key')) {
        return "Sorry, I'm having technical difficulties at the moment. Please try again soon.";
      } else if (e.toString().contains('model')) {
        return "I need a moment to catch up. Mind trying again?";
      }
      return "Could you rephrase that? I didn't quite catch what you meant.";
    }
  }

  String _cleanResponse(String response) {
    // First, clean up any special characters and formatting
    var cleaned = response
        .replaceAll(
            RegExp(r'\*.*?\*'), '') // Remove asterisks and content between them
        .replaceAll(
            RegExp(r'\[.*?\]'), '') // Remove square brackets and content
        .replaceAll(RegExp(r'\(.*?\)'), '') // Remove parentheses and content
        .replaceAll(RegExp(r'\\u\d+'), '') // Remove Unicode escapes
        .replaceAll(RegExp(r'#+ '), ''); // Remove heading markers

    // Split into lines and process each line
    var lines = cleaned.split('\n');
    var formattedLines = <String>[];
    var isInList = false;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Format bullet points
      if (line.startsWith('•') || line.startsWith('-')) {
        isInList = true;
        line = '• ' + line.substring(line.indexOf(' ') + 1).trim();
        if (formattedLines.isNotEmpty && !formattedLines.last.startsWith('•')) {
          formattedLines.add(''); // Add space before first bullet point
        }
      } else {
        if (isInList && formattedLines.isNotEmpty) {
          formattedLines.add(''); // Add space after last bullet point
        }
        isInList = false;
      }

      // Clean up the line
      line = line
          .replaceAll(RegExp(r' +'), ' ') // Remove multiple spaces
          .replaceAll(' ,', ',')
          .replaceAll(' .', '.')
          .replaceAll(' !', '!')
          .replaceAll(' ?', '?');

      // Ensure proper capitalization
      if (!line.startsWith('•')) {
        line = line[0].toUpperCase() + line.substring(1);
      }

      formattedLines.add(line);
    }

    // Join lines and final cleanup
    cleaned = formattedLines.join('\n').trim();

    // Ensure the response ends with proper punctuation
    if (!cleaned.endsWith('.') &&
        !cleaned.endsWith('!') &&
        !cleaned.endsWith('?')) {
      cleaned += '.';
    }

    return cleaned;
  }
}
