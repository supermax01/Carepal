class PromisQuestion {
  final String fieldName;
  final String formName;
  final String sectionHeader;
  final String fieldType;
  final String fieldLabel;
  final List<PromisChoice> choices;
  final String fieldNote;
  final String validationType;
  final String validationMin;
  final String validationMax;
  final bool isIdentifier;
  final String branchingLogic;
  final bool isRequired;
  final String customAlignment;
  final String questionNumber;
  final String matrixGroupName;
  final String matrixRanking;
  final String fieldAnnotation;

  PromisQuestion({
    required this.fieldName,
    required this.formName,
    required this.sectionHeader,
    required this.fieldType,
    required this.fieldLabel,
    required this.choices,
    required this.fieldNote,
    required this.validationType,
    required this.validationMin,
    required this.validationMax,
    required this.isIdentifier,
    required this.branchingLogic,
    required this.isRequired,
    required this.customAlignment,
    required this.questionNumber,
    required this.matrixGroupName,
    required this.matrixRanking,
    required this.fieldAnnotation,
  });

  factory PromisQuestion.fromJson(Map<String, dynamic> json) {
    List<PromisChoice> choices = [];
    if (json['select_choices_or_calculations'] != null &&
        json['select_choices_or_calculations'].toString().isNotEmpty) {
      final choicesStr = json['select_choices_or_calculations'].toString();
      final choicesList = choicesStr.split('|');
      for (var choice in choicesList) {
        final parts = choice.trim().split(',');
        if (parts.length >= 2) {
          choices.add(PromisChoice(
            value: parts[0].trim(),
            label: parts[1].trim(),
          ));
        }
      }
    }

    return PromisQuestion(
      fieldName: json['field_name'] ?? '',
      formName: json['form_name'] ?? '',
      sectionHeader: json['section_header'] ?? '',
      fieldType: json['field_type'] ?? '',
      fieldLabel: json['field_label'] ?? '',
      choices: choices,
      fieldNote: json['field_note'] ?? '',
      validationType: json['text_validation_type_or_show_slider_number'] ?? '',
      validationMin: json['text_validation_min'] ?? '',
      validationMax: json['text_validation_max'] ?? '',
      isIdentifier: json['identifier'] == 'y',
      branchingLogic: json['branching_logic'] ?? '',
      isRequired: json['required_field'] == 'y',
      customAlignment: json['custom_alignment'] ?? '',
      questionNumber: json['question_number'] ?? '',
      matrixGroupName: json['matrix_group_name'] ?? '',
      matrixRanking: json['matrix_ranking'] ?? '',
      fieldAnnotation: json['field_annotation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_name': fieldName,
      'form_name': formName,
      'field_type': fieldType,
      'field_label': fieldLabel,
      'required_field': isRequired ? 'y' : 'n',
      'branching_logic': branchingLogic,
      'custom_alignment': customAlignment,
    };
  }
}

class PromisChoice {
  final String value;
  final String label;

  PromisChoice({
    required this.value,
    required this.label,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}

class PromisForm {
  final String formName;
  final String formLabel;
  final List<PromisQuestion> questions;
  final PromisScores? scores;

  PromisForm({
    required this.formName,
    required this.formLabel,
    required this.questions,
    this.scores,
  });
}

class PromisScores {
  final String? tScore;
  final String? standardError;

  PromisScores({
    this.tScore,
    this.standardError,
  });
}
