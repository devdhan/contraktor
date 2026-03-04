import 'package:flutter/material.dart';

class RequestServiceForm extends StatefulWidget {
  final String artisanId;

  final Future<void> Function(
    String title,
    String description,
    String address,
    String date,
    String urgency,
  )
  onSubmit;

  const RequestServiceForm({
    super.key,
    required this.artisanId,
    required this.onSubmit,
  });

  @override
  State<RequestServiceForm> createState() => _RequestServiceFormState();
}

class _RequestServiceFormState extends State<RequestServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _selectedDate = '';
  bool _isSubmitting = false;

  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Emergency'];
  String _selectedUrgency = 'Medium';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: Colors.greenAccent.shade700),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(
        () => _selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a preferred date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(
        _titleCtrl.text.trim(),
        _descCtrl.text.trim(),
        _addressCtrl.text.trim(),
        _selectedDate,
        _selectedUrgency,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request sent successfully!'),
          backgroundColor: Color(0xFF22C55E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request Service',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Fill in the details and we\'ll notify the artisan',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Service Title'),
                      _textField(
                        controller: _titleCtrl,
                        hint: 'e.g. Fix leaking kitchen pipe',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a service title'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _label('Description'),
                      _textField(
                        controller: _descCtrl,
                        hint: 'Describe the issue or work needed...',
                        maxLines: 3,
                        validator: (v) => (v == null || v.trim().length < 10)
                            ? 'Please add more detail (min 10 chars)'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _label('Service Address'),
                      _textField(
                        controller: _addressCtrl,
                        hint: 'Enter your address',
                        prefix: Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Colors.greenAccent.shade700,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your address'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _label('Preferred Date'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 20,
                                color: Colors.greenAccent.shade700,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _selectedDate.isEmpty
                                    ? 'Select a date'
                                    : _selectedDate,
                                style: TextStyle(
                                  color: _selectedDate.isEmpty
                                      ? Colors.grey[400]
                                      : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _label('Urgency Level'),
                      const SizedBox(height: 5),
                      Row(
                        children: _urgencyLevels.map((u) {
                          final selected = _selectedUrgency == u;
                          final color = u == 'Emergency'
                              ? Colors.red
                              : u == 'High'
                              ? Colors.orange
                              : u == 'Medium'
                              ? Colors.greenAccent.shade700
                              : Colors.green;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedUrgency = u),
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? color.withOpacity(0.1)
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? color
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  u,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? color : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    disabledBackgroundColor: Colors.greenAccent.shade700
                        .withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Widget? prefix,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    maxLines: maxLines,
    validator: validator,
    cursorColor: Colors.greenAccent.shade700,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      prefixIcon: prefix,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );
}
