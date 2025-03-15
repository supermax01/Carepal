import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class RedcapService {
  final String baseUrl;
  late final String apiKey;

  RedcapService({required this.baseUrl}) {
    _initialize();
  }

  Future<void> _initialize() async {
    apiKey = await Environment.redcapApiKey;
  }

  Future<Map<String, dynamic>> fetchQuestionnaire() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'token': apiKey,
          'content': 'metadata',
          'format': 'json',
          'returnFormat': 'json',
          'forms[0]': 'promis29_2',
          'fields[0]': 'field_name',
          'fields[1]': 'form_name',
          'fields[2]': 'field_type',
          'fields[3]': 'field_label',
          'fields[4]': 'select_choices_or_calculations',
          'fields[5]': 'required_field',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Transform the data into a more usable format
        final Map<String, List<Map<String, dynamic>>> organizedData = {};

        for (var field in data) {
          final String formName = field['form_name'];
          if (!organizedData.containsKey(formName)) {
            organizedData[formName] = [];
          }

          // Parse choices if they exist
          List<Map<String, String>> choices = [];
          if (field['select_choices_or_calculations'] != null &&
              field['select_choices_or_calculations'].toString().isNotEmpty) {
            final choicesStr =
                field['select_choices_or_calculations'].toString();
            final choicesList = choicesStr.split('|');
            for (var choice in choicesList) {
              final parts = choice.trim().split(',');
              if (parts.length >= 2) {
                choices.add({
                  'value': parts[0].trim(),
                  'label': parts[1].trim(),
                });
              }
            }
          }

          organizedData[formName]!.add({
            'field_name': field['field_name'],
            'field_type': field['field_type'],
            'field_label': field['field_label'],
            'required': field['required_field'] == 'y',
            'choices': choices,
          });
        }

        return {'success': true, 'data': organizedData};
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch questionnaire: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error fetching questionnaire: $e'};
    }
  }
}
