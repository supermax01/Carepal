import 'package:flutter/material.dart';
import '../models/promis_question.dart';
import '../services/promis_form_service.dart';
import '../services/redcap_api_service.dart';
import '../utils/error_handler.dart';

class PromisFormScreen extends StatefulWidget {
  final PromisForm form;
  final String recordId;
  final Function(bool success)? onComplete;

  const PromisFormScreen({
    Key? key,
    required this.form,
    required this.recordId,
    this.onComplete,
  }) : super(key: key);

  @override
  State<PromisFormScreen> createState() => _PromisFormScreenState();
}

class _PromisFormScreenState extends State<PromisFormScreen> {
  final Map<String, String> _responses = {};
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.form.formLabel),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: _isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ...widget.form.questions
                      .map((question) => _buildQuestion(question)),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: _canSubmit() ? _submitForm : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildQuestion(PromisQuestion question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.sectionHeader.isNotEmpty) ...[
              Text(
                question.sectionHeader,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              question.fieldLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            _buildAnswerOptions(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(PromisQuestion question) {
    return Column(
      children: question.choices.map((choice) {
        return RadioListTile<String>(
          title: Text(choice.label),
          value: choice.value,
          groupValue: _responses[question.fieldName],
          onChanged: (value) {
            setState(() {
              if (value != null) {
                _responses[question.fieldName] = value;
              }
            });
          },
        );
      }).toList(),
    );
  }

  bool _canSubmit() {
    if (_isSubmitting) return false;
    return widget.form.questions.every((question) =>
        !question.isRequired || _responses.containsKey(question.fieldName));
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);

    try {
      final service = await RedcapApiService.instance;
      final success = await service.submitResponses(
        widget.recordId,
        widget.form.formName,
        _responses,
      );

      if (mounted) {
        if (success) {
          widget.onComplete?.call(true);
          Navigator.of(context).pop(true);
        } else {
          RedcapErrorHandler.showError(
            context,
            'Failed to submit form responses',
          );
          widget.onComplete?.call(false);
        }
      }
    } catch (e) {
      if (mounted) {
        RedcapErrorHandler.showError(
          context,
          RedcapErrorHandler.getErrorMessage(e),
        );
        widget.onComplete?.call(false);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
