// File: lib/correspondences/widgets/correspondence_form.dart

import 'package:flutter/material.dart';
import 'package:correspondence_tracker/correspondences/models/correspondence.dart';
import 'package:correspondence_tracker/correspondences/models/correspondence_request.dart';
import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:correspondence_tracker/shared/models/enums.dart';

// Import models needed for dropdowns
import 'package:correspondence_tracker/users/models/user.dart';
import 'package:correspondence_tracker/departments/models/department.dart';
import 'package:correspondence_tracker/correspondents/models/correspondent.dart';
import 'package:correspondence_tracker/classifications/models/classification.dart';
import 'package:correspondence_tracker/subjects/models/subject.dart';

class CorrespondenceForm extends StatefulWidget {
  /// The existing correspondence to edit, or null if creating a new one.
  final Correspondence? correspondence;
  
  /// Event emitted when the form is submitted.
  final Function(CorrespondenceRequest) onSubmit;
  
  /// Flag to show a loading indicator on the save button.
  final bool isSaving;
  
  // Data for dropdowns, provided by parent widget (from Cubits)
  final List<User> users;
  final List<Department> departments;
  final List<Correspondent> correspondents;
  final List<Classification> classifications;
  final List<Subject> subjects;

  const CorrespondenceForm({
    super.key,
    this.correspondence,
    required this.onSubmit,
    this.isSaving = false,
    required this.users,
    required this.departments,
    required this.correspondents,
    required this.classifications,
    required this.subjects,
  });

  @override
  State<CorrespondenceForm> createState() => _CorrespondenceFormState();
}

class _CorrespondenceFormState extends State<CorrespondenceForm> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEditMode;

  // Text Controllers
  late final TextEditingController _contentController;
  late final TextEditingController _summaryController;
  late final TextEditingController _incomingNumberController;
  late final TextEditingController _outgoingNumberController;
  late final TextEditingController _notesController;

  // State for dropdowns and pickers
  String? _senderId;
  String? _subjectId;
  String? _departmentId;
  String? _followUpUserId;
  String? _responsibleUserId;
  DateOnly? _incomingDate;
  DateOnly? _outgoingDate;
  CorrespondenceDirection _direction = CorrespondenceDirection.incoming;
  PriorityLevel _priorityLevel = PriorityLevel.medium;
  bool _isClosed = false;
  final List<String> _classificationIds = [];
  
  // TODO: Implement reminder management UI (dialog, etc.)
  final List<ReminderDto> _reminders = [];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.correspondence != null;

    // Initialize controllers
    _contentController = TextEditingController();
    _summaryController = TextEditingController();
    _incomingNumberController = TextEditingController();
    _outgoingNumberController = TextEditingController();
    _notesController = TextEditingController();

    if (_isEditMode) {
      // Populate form from existing correspondence
      final item = widget.correspondence!;
      _contentController.text = item.content ?? '';
      _summaryController.text = item.summary ?? '';
      _incomingNumberController.text = item.incomingNumber ?? '';
      _outgoingNumberController.text = item.outgoingNumber ?? '';
      _notesController.text = item.notes ?? '';

      _senderId = item.correspondent?.id;
      _subjectId = item.subject?.id;
      _departmentId = item.department?.id;
      _followUpUserId = item.followUpUser?.id;
      _responsibleUserId = item.responsibleUser?.id;
      _incomingDate = item.incomingDate;
      _outgoingDate = item.outgoingDate;
      _direction = item.direction;
      _priorityLevel = item.priorityLevel;
      _isClosed = item.isClosed;
      _classificationIds.addAll(item.classifications.map((c) => c.id));
      // TODO: Populate _reminders from item.reminders
      
    } else {
      // Set defaults for a new correspondence
      _incomingDate = DateOnly.today();
      _outgoingDate = DateOnly.today(); // Angular default
      _priorityLevel = PriorityLevel.medium;
      _isClosed = false;
      _direction = CorrespondenceDirection.incoming;
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _contentController.dispose();
    _summaryController.dispose();
    _incomingNumberController.dispose();
    _outgoingNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Handles form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final request = CorrespondenceRequest(
        id: _isEditMode ? widget.correspondence!.id : null,
        senderId: _senderId,
        content: _contentController.text,
        summary: _summaryController.text,
        subjectId: _subjectId,
        classificationIds: _classificationIds,
        incomingNumber: _incomingNumberController.text,
        incomingDate: _incomingDate,
        outgoingNumber: _outgoingNumberController.text,
        outgoingDate: _outgoingDate,
        departmentId: _departmentId,
        followUpUserId: _followUpUserId,
        responsibleUserId: _responsibleUserId,
        priorityLevel: _priorityLevel,
        notes: _notesController.text,
        isClosed: _isClosed,
        direction: _direction,
        reminders: _reminders.isNotEmpty ? _reminders : null,
      );

      widget.onSubmit(request);
    }
  }

  /// Helper to show a Date Picker
  Future<void> _selectDate(BuildContext context, bool isIncoming) async {
    final initialDate = (isIncoming ? _incomingDate : _outgoingDate)
        ?? DateOnly.today();
        
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isIncoming) {
          _incomingDate = DateOnly.fromDateTime(picked);
        } else {
          _outgoingDate = DateOnly.fromDateTime(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Direction (Incoming/Outgoing)
            _buildDropdown<CorrespondenceDirection>(
              label: 'اتجاه الخطاب *',
              value: _direction,
              items: CorrespondenceDirection.values,
              itemBuilder: (dir) => DropdownMenuItem(
                value: dir,
                child: Text(dir == CorrespondenceDirection.incoming ? 'وارد' : 'صادر'),
              ),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _direction = val);
                }
              },
              validator: (val) => val == null ? 'مطلوب' : null,
            ),
            
            // Sender (Correspondent)
            _buildDropdown<String?>(
              label: 'الجهة المرسلة *',
              value: _senderId,
              items: widget.correspondents,
              itemBuilder: (item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              ),
              onChanged: (val) => setState(() => _senderId = val),
              validator: (val) => val == null ? 'مطلوب' : null,
            ),
            
            // Content
            _buildTextField(
              controller: _contentController,
              label: 'محتوى الخطاب',
              maxLines: 5,
            ),
            
            // Summary
            _buildTextField(
              controller: _summaryController,
              label: 'ملخص الخطاب',
              maxLines: 3,
            ),
            
            // Subject
            _buildDropdown<String?>(
              label: 'موضوع الخطاب',
              value: _subjectId,
              items: widget.subjects,
              itemBuilder: (item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              ),
              onChanged: (val) => setState(() => _subjectId = val),
              allowNull: true,
            ),
            
            // Classifications (Multi-select)
            _buildClassificationChips(),
            
            // Incoming Number & Date
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _incomingNumberController,
                    label: 'رقم وارد',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDatePicker(
                    context: context,
                    label: 'تاريخ الوارد',
                    date: _incomingDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
              ],
            ),
            
            // Outgoing Number & Date
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _outgoingNumberController,
                    label: 'رقم صادر',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDatePicker(
                    context: context,
                    label: 'تاريخ الصادر',
                    date: _outgoingDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            
            // Department
            _buildDropdown<String?>(
              label: 'الإدارة المسؤولة',
              value: _departmentId,
              items: widget.departments,
              itemBuilder: (item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name),
              ),
              onChanged: (val) => setState(() => _departmentId = val),
              allowNull: true,
            ),
            
            // Follow-up User
            _buildDropdown<String?>(
              label: 'مسؤول المتابعة',
              value: _followUpUserId,
              items: widget.users,
              itemBuilder: (item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name), // Assuming User has 'name'
              ),
              onChanged: (val) => setState(() => _followUpUserId = val),
              allowNull: true,
            ),
            
            // Responsible User
            _buildDropdown<String?>(
              label: 'المختص',
              value: _responsibleUserId,
              items: widget.users,
              itemBuilder: (item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name), // Assuming User has 'name'
              ),
              onChanged: (val) => setState(() => _responsibleUserId = val),
              allowNull: true,
            ),

            // Priority
            _buildDropdown<PriorityLevel>(
              label: 'مستوى الأهمية *',
              value: _priorityLevel,
              items: PriorityLevel.values,
              itemBuilder: (p) => DropdownMenuItem(
                value: p,
                child: Text(_getPriorityLabel(p)),
              ),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _priorityLevel = val);
                }
              },
              validator: (val) => val == null ? 'مطلوب' : null,
            ),

            // Notes
            _buildTextField(
              controller: _notesController,
              label: 'ملاحظات',
              maxLines: 2,
            ),

            // Is Closed
            SwitchListTile(
              title: const Text('تم إغلاق الخطاب'),
              value: _isClosed,
              onChanged: (val) => setState(() => _isClosed = val),
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 24),
            
            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: widget.isSaving ? null : _submitForm,
              child: widget.isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Helper to build a standard text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: (val) => controller.text = val ?? '',
      ),
    );
  }

  /// Generic helper to build a dropdown field
  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<dynamic> items,
    required DropdownMenuItem<T> Function(dynamic item) itemBuilder,
    required void Function(T?) onChanged,
    bool allowNull = false,
    String? Function(T?)? validator,
  }) {
    final dropdownItems = items.map<DropdownMenuItem<T>>(itemBuilder).toList();
    
    if (allowNull) {
      dropdownItems.insert(0, DropdownMenuItem<T>(value: null, child: const Text(' ')));
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: dropdownItems,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  /// Helper to build the date picker "field"
  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateOnly? date,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date?.toString() ?? 'Select Date',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  /// Helper to get priority labels (from edit-correspondence.ts)
  String _getPriorityLabel(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.urgentAndImportant: return 'هام وعاجل';
      case PriorityLevel.urgent: return 'عاجل';
      case PriorityLevel.important: return 'هام';
      case PriorityLevel.medium: return 'متوسط';
      case PriorityLevel.low: return 'منخفض';
      default: return p.toString();
    }
  }

  /// Helper to build multi-select chips for classifications
  Widget _buildClassificationChips() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'التصنيف',
        border: InputBorder.none,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.classifications.map((classification) {
            final isSelected = _classificationIds.contains(classification.id);
            return FilterChip(
              label: Text(classification.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _classificationIds.add(classification.id);
                  } else {
                    _classificationIds.remove(classification.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}