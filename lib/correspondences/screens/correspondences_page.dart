import 'package:correspondence_tracker/correspondences/screens/correspondence_page.dart';
import 'package:correspondence_tracker/shared/widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../cubit/correspondences_cubit.dart';
import '../cubit/correspondences_state.dart';
import '../models/correspondence.dart';
import '../models/get_correspondences_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/correspondence_list.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/stats_header.dart'; // For date formatting

class CorrespondencePage extends StatefulWidget {
  const CorrespondencePage({super.key});

  @override
  State<CorrespondencePage> createState() => _CorrespondencePageState();
}

class _CorrespondencePageState extends State<CorrespondencePage> {

  late GetCorrespondencesFilterModel _filter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = const GetCorrespondencesFilterModel(isClosed: false);
    _searchController.addListener(_onSearchChanged);
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Add New Page')));
  }

  void _onImportFromExcel() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Implement Excel Import')));
  }

  void _onItemTap(Correspondence item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CorrespondenceDetailPage(item.id)),
    );
  }

  void _onEditItem(Correspondence item) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${item.id}')));
  }

  void _onDeleteItem(Correspondence item) {
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

                    final total = state.correspondences.length;
                    final open = state.correspondences
                        .where((c) => !c.isClosed)
                        .length;
                    final closed = total - open;

                    return Column(
                      children: [
                        StatsHeader(total: total, open: open, closed: closed),
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
