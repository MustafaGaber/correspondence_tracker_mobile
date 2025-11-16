import 'package:correspondence_tracker/correspondences/screens/correspondence_page.dart';
import 'package:correspondence_tracker/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../cubit/correspondences_cubit.dart';
import '../cubit/correspondences_state.dart';
import '../models/correspondence.dart';
import '../models/get_correspondences_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../widgets/correspondence_list.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/stats_header.dart'; // For date formatting

class CorrespondencePage extends StatefulWidget {
  const CorrespondencePage({super.key});

  @override
  State<CorrespondencePage> createState() => _CorrespondencePageState();
}

class _CorrespondencePageState extends State<CorrespondencePage> {
  // State for filters and search
  late GetCorrespondencesFilterModel _filter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with default filters
    _filter = const GetCorrespondencesFilterModel(isClosed: false);
    _searchController.addListener(_onSearchChanged);

    // Load initial data
    _loadData();
  }

  void _loadData() {
    context.read<CorrespondencesCubit>().loadCorrespondences(_filter);
  }

  void _onSearchChanged() {
    // Debounce this in a real app
    setState(() {
      _filter = _filter.copyWith(searchTerm: _searchController.text);
    });
    _loadData();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filter = _filter.copyWith(searchTerm: null);
    });
    _loadData();
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return AdvancedFilterSheet(
          initialFilter: _filter,
          onApplyFilters: (newFilter) {
            setState(() {
              _filter = newFilter;
            });
            _loadData();
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  void _onAddNew() {
    // TODO: Navigate to create/edit screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => EditCorrespondencePage()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Add New Page')));
  }

  void _onImportFromExcel() {
    // TODO: Implement file picking logic
    // FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Implement Excel Import')));
  }

  void _onItemTap(Correspondence item) {
    // TODO: Navigate to detail screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(item.id)));
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CorrespondenceDetailPage(item.id)),
    );
  }

  void _onEditItem(Correspondence item) {
    // TODO: Navigate to edit screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => EditCorrespondencePage(item: item)));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${item.id}')));
  }

  void _onDeleteItem(Correspondence item) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الخطاب "${item.summary}"؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(ctx),
          ),
          FilledButton(
            child: const Text('حذف'),
            onPressed: () {
              context.read<CorrespondencesCubit>().deleteCorrespondence(
                item.id,
              );
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _onViewFile(Correspondence item) {
    // TODO: Implement file download/view logic from service
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('View file ${item.fileId}')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('الخطابات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: 'بحث متقدم',
              onPressed: _showAdvancedFilters,
            ),
            IconButton(
              icon: const Icon(Icons.file_upload_outlined),
              tooltip: 'إضافة من إكسل',
              onPressed: _onImportFromExcel,
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => _loadData(),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'بحث',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              // Main Content
              Expanded(
                child: BlocBuilder<CorrespondencesCubit, CorrespondencesState>(
                  builder: (context, state) {
                    if (state.isLoading && state.correspondences.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.correspondences.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد خطابات.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    }

                    // Calculate stats
                    final total = state.correspondences.length;
                    final open = state.correspondences
                        .where((c) => !c.isClosed)
                        .length;
                    final closed = total - open;

                    return Column(
                      children: [
                        // Stats Header (Dumb Widget)
                        StatsHeader(total: total, open: open, closed: closed),
                        // List (Dumb Widget)
                        Expanded(
                          child: CorrespondenceList(
                            correspondences: state.correspondences,
                            onItemTap: _onItemTap,
                            onEditTap: _onEditItem,
                            onDeleteTap: _onDeleteItem,
                            onViewFileTap: _onViewFile,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddNew,
          tooltip: 'إضافة خطاب جديد',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Add this to your model for easy filter updates
extension FilterCopyWith on GetCorrespondencesFilterModel {
  GetCorrespondencesFilterModel copyWith({
    String? searchTerm,
    int? direction,
    int? priorityLevel,
    bool? isClosed,
    // ... other fields
  }) {
    return GetCorrespondencesFilterModel(
      searchTerm: searchTerm ?? this.searchTerm,
      direction: direction ?? this.direction,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      isClosed: isClosed ?? this.isClosed,
      // ...
    );
  }
}
