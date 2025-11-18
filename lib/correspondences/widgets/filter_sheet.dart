import 'package:flutter/material.dart';
import '../../shared/models/enums.dart';
import '../models/get_correspondences_filter_model.dart'; // For PriorityLevel, etc.

class AdvancedFilterSheet extends StatefulWidget {
  final GetCorrespondencesFilterModel initialFilter;
  final ValueChanged<GetCorrespondencesFilterModel> onApplyFilters;

  const AdvancedFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApplyFilters,
  });

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  late GetCorrespondencesFilterModel _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  void _clearFilters() {
    setState(() {
      _filter = const GetCorrespondencesFilterModel(isClosed: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16, 20, 16, 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بحث متقدم',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // TODO: Add all your dropdowns, e.g.:
              // DropdownButtonFormField<int?>(...)
              
              // Example: Priority Dropdown
              DropdownButtonFormField<int?>(
               // value: _filter.priorityLevel?.value,
                decoration: const InputDecoration(
                  labelText: 'مستوى الأهمية',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('الكل')),
                  ...PriorityLevel.values.map((p) => DropdownMenuItem(
                        value: p.value,
                        child: Text(_getPriorityLabel(p)),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _filter = _filter.copyWith(
                      priorityLevel: value,
                    );
                  });
                },
              ),

              const SizedBox(height: 16),

              // TODO: Add Date Pickers for fromDate/toDate

              // Example: isClosed Checkbox
              SwitchListTile(
                title: const Text('إظهار المفتوحة فقط'),
                value: !_filter.isClosed,
                onChanged: (value) {
                  setState(() {
                    _filter = _filter.copyWith(isClosed: !value);
                  });
                },
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _clearFilters,
                    child: const Text('مسح البحث'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => widget.onApplyFilters(_filter),
                    icon: const Icon(Icons.check),
                    label: const Text('تطبيق'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.critical: return 'حرج';
      case PriorityLevel.urgentAndImportant: return 'هام وعاجل';
      case PriorityLevel.urgent: return 'عاجل';
      case PriorityLevel.important: return 'هام';
      case PriorityLevel.medium: return 'متوسط';
      case PriorityLevel.low: return 'منخفض';
    }
  }
}

// Add copyWith to the model you generated earlier
extension FilterCopyWith on GetCorrespondencesFilterModel {
  GetCorrespondencesFilterModel copyWith({
    String? searchTerm,
    int? direction,
    PriorityLevel? priorityLevel,
    bool? isClosed,
    // ... other fields
  }) {
    return GetCorrespondencesFilterModel(
      searchTerm: searchTerm ?? this.searchTerm,
      direction: direction ?? this.direction,
      priorityLevel: priorityLevel?.value ?? this.priorityLevel,
      isClosed: isClosed ?? this.isClosed,
      // ...
    );
  }
}