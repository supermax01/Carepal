import 'package:flutter/material.dart';
import '../models/promis_question.dart';
import '../services/promis_form_service.dart';
import '../utils/error_handler.dart';
import '../services/redcap_api_service.dart';
import 'promis_form_screen.dart';

class PromisFormsScreen extends StatefulWidget {
  final String recordId;

  const PromisFormsScreen({
    Key? key,
    required this.recordId,
  }) : super(key: key);

  @override
  State<PromisFormsScreen> createState() => _PromisFormsScreenState();
}

class _PromisFormsScreenState extends State<PromisFormsScreen> {
  bool _isLoading = true;
  List<PromisForm>? _forms;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadForms();
  }

  Future<void> _loadForms() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final service = await RedcapApiService.instance;
      final forms = await service.getPromisForms();

      if (mounted) {
        setState(() {
          _forms = forms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = RedcapErrorHandler.getErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openForm(PromisForm form) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PromisFormScreen(
          form: form,
          recordId: widget.recordId,
          onComplete: (success) {
            if (success) {
              // TODO: Update form status or refresh list
            }
          },
        ),
      ),
    );

    if (result == true) {
      // Form was submitted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROMIS Forms'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadForms,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadForms,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_forms == null || _forms!.isEmpty) {
      return const Center(
        child: Text('No PROMIS forms available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _forms!.length,
      itemBuilder: (context, index) {
        final form = _forms![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(form.formLabel),
            subtitle: Text('${form.questions.length} questions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openForm(form),
          ),
        );
      },
    );
  }
}
