import '../models/promis_question.dart';

class PromisFormService {
  /// Processes raw metadata into organized PROMIS forms
  static List<PromisForm> processMetadata(Map<String, List<dynamic>> rawData) {
    List<PromisForm> forms = [];

    rawData.forEach((formName, questions) {
      if (formName.startsWith('promis_')) {
        // Get form label from first question's form_name
        String formLabel = questions.isNotEmpty
            ? questions.first['form_label'] ?? formName
            : formName;

        // Separate questions and score fields
        List<PromisQuestion> formQuestions = [];
        PromisScores? scores;

        for (var questionData in questions) {
          final question = PromisQuestion.fromJson(questionData);

          // Check if it's a score field
          if (question.fieldName.contains('_tscore') ||
              question.fieldName.contains('_std_error')) {
            scores ??= PromisScores(
              tScore: question.fieldName.contains('_tscore') ? '' : null,
              standardError:
                  question.fieldName.contains('_std_error') ? '' : null,
            );
          } else if (question.fieldType == 'radio') {
            // Add only actual questions (radio type)
            formQuestions.add(question);
          }
        }

        // Sort questions by their field names if they have numeric identifiers
        formQuestions.sort((a, b) {
          final aNum =
              int.tryParse(a.fieldName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          final bNum =
              int.tryParse(b.fieldName.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return aNum.compareTo(bNum);
        });

        forms.add(PromisForm(
          formName: formName,
          formLabel: formLabel,
          questions: formQuestions,
          scores: scores,
        ));
      }
    });

    return forms;
  }

  /// Validates if all required questions are answered
  static bool validateResponses(
      PromisForm form, Map<String, String> responses) {
    for (var question in form.questions) {
      if (question.isRequired && !responses.containsKey(question.fieldName)) {
        return false;
      }
    }
    return true;
  }

  /// Formats responses for submission to REDCap
  static Map<String, dynamic> formatResponsesForSubmission(
    String recordId,
    PromisForm form,
    Map<String, String> responses,
  ) {
    final Map<String, dynamic> formatted = {
      'record_id': recordId,
    };

    // Add responses
    responses.forEach((fieldName, value) {
      formatted[fieldName] = value;
    });

    // Add score fields with empty values (will be calculated by REDCap)
    if (form.scores != null) {
      if (form.scores!.tScore != null) {
        formatted['${form.formName}_tscore'] = '';
      }
      if (form.scores!.standardError != null) {
        formatted['${form.formName}_std_error'] = '';
      }
    }

    return formatted;
  }
}
