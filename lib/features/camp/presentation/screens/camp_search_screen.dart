import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camp/presentation/widgets/camp_card.dart';

class CampSearchScreen extends StatefulWidget {
  const CampSearchScreen({super.key});

  @override
  State<CampSearchScreen> createState() => _CampSearchScreenState();
}

class _CampSearchScreenState extends State<CampSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampProvider>().clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim();
      context.read<CampProvider>().searchLocalCamps(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.summerPrimary,
        title: const Text(
          "Tìm kiếm Trại hè",
          style: TextStyle(
            fontFamily: "Quicksand",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchField(),
          ),
          Expanded(
            child: Consumer<CampProvider>(
              builder: (context, provider, child) {
                if (_searchController.text.isEmpty) {
                  return _buildInitialView();
                }
                if (provider.filteredCamps.isEmpty) {
                  return _buildEmptyView();
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: provider.filteredCamps.length,
                  itemBuilder: (context, index) {
                    final camp = provider.filteredCamps[index];
                    return CampCard(camp: camp);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: "Tìm kiếm theo tên trại...",
        hintStyle: TextStyle(fontFamily: "Quicksand", color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),

        prefixIcon: const Icon(Icons.search, color: AppTheme.summerPrimary),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  context.read<CampProvider>().clearSearch();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Nhập tên trại bạn muốn tìm",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Không tìm thấy kết quả nào",
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
