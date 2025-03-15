import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promis_question.dart';
import '../../config/env.dart';

class RedcapApiService {
  static RedcapApiService? _instance;
  static Future<RedcapApiService> get instance async {
    if (_instance == null) {
      _instance = RedcapApiService._internal();
      await _instance!._initialize();
    }
    return _instance!;
  }

  late final String _baseUrl;
  late final String _token;

  // PROMIS form names from your REDCap project
  static const promisInstruments = [
    'promis_sf_v20_physical_function_4a',
    'promis_sf_v10_anxiety_4a',
    'promis_sf_v10_depression_4a',
    'promis_sf_v10_fatigue_4a',
    'promis_sf_v10_sleep_disturbance_4a_3c77',
    'promis_sf_v20_ability_to_participate_social_4a',
    'promis_sf_v10_pain_interference_4a',
    'promis_v10_pain_intensity_1a',
    'promis_sf_v20_cognitive_function_abilities_2a',
  ];

  RedcapApiService._internal();

  Future<void> _initialize() async {
    _baseUrl = await Environment.redcapApiUrl;
    _token = await Environment.redcapApiKey;
    print('REDCap Service Initialized:');
    print('Base URL: $_baseUrl');
    print('Token length: ${_token.length}');
  }

  /// Fetches PROMIS forms metadata from REDCap
  Future<List<PromisForm>> getPromisForms() async {
    try {
      // Create the request body exactly as shown in the Python example
      final Map<String, String> requestBody = {
        'token': _token,
        'content': 'metadata',
        'format': 'json',
        'returnFormat': 'json',
      };

      // Add all PROMIS forms to the request
      for (var i = 0; i < promisInstruments.length; i++) {
        requestBody['forms[$i]'] = promisInstruments[i];
      }

      // Add required fields
      final fields = [
        'field_name',
        'form_name',
        'field_type',
        'field_label',
        'select_choices_or_calculations',
        'required_field',
        'branching_logic',
        'custom_alignment',
        'matrix_group_name',
        'matrix_ranking',
        'question_number'
      ];

      for (var i = 0; i < fields.length; i++) {
        requestBody['fields[$i]'] = fields[i];
      }

      print('Making REDCap API request to: $_baseUrl');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        body: requestBody,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final Map<String, List<dynamic>> organizedData = {};

        // Organize data by form name
        for (var item in data) {
          final formName = item['form_name'] as String;
          if (!organizedData.containsKey(formName)) {
            organizedData[formName] = [];
          }
          organizedData[formName]!.add(item);
        }

        // Convert to PromisForm objects
        final List<PromisForm> forms = [];
        organizedData.forEach((formName, questions) {
          if (formName.startsWith('promis_')) {
            final formQuestions = questions
                .map((q) => PromisQuestion.fromJson(q))
                .where((q) => q.fieldType == 'radio')
                .toList();

            if (formQuestions.isNotEmpty) {
              forms.add(PromisForm(
                formName: formName,
                formLabel: _getFormLabel(formName),
                questions: formQuestions,
              ));
            }
          }
        });

        print('Successfully loaded ${forms.length} forms');
        return forms;
      }
      throw Exception(
          'Failed to load forms: ${response.statusCode}\nResponse: ${response.body}');
    } catch (e) {
      print('Error in getPromisForms: $e');
      throw Exception('Error loading forms: $e');
    }
  }

  /// Submits PROMIS form responses to REDCap
  Future<bool> submitResponses(
    String recordId,
    String formName,
    Map<String, String> responses,
  ) async {
    try {
      // Prepare the data in REDCap format
      final Map<String, dynamic> record = {
        'record_id': recordId,
        ...responses,
      };

      final requestBody = {
        'token': _token,
        'content': 'record',
        'format': 'json',
        'type': 'flat',
        'returnFormat': 'json',
        'data': json.encode([record]),
      };

      print('Submitting responses to REDCap:');
      print('URL: $_baseUrl');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        body: requestBody,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      }
      throw Exception(
          'Failed to submit responses: ${response.statusCode}\nResponse: ${response.body}');
    } catch (e) {
      print('Error in submitResponses: $e');
      throw Exception('Error submitting responses: $e');
    }
  }

  String _getFormLabel(String formName) {
    // Convert form name to readable label
    final name = formName
        .replaceAll('promis_', '')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'v\d+'), '')
        .replaceAll(RegExp(r'\d+[a-z]'), '')
        .trim();

    return name
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
