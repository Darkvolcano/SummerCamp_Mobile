import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/camp/presentation/state/camp_provider.dart';
import 'package:summercamp/features/camp/presentation/widgets/camp_card.dart';

class CampListScreen extends StatefulWidget {
  const CampListScreen({super.key});

  @override
  State<CampListScreen> createState() => _CampListScreenState();
}

class _CampListScreenState extends State<CampListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CampProvider>();
      if (provider.camps.isEmpty) {
        provider.loadCamps();
      }
      if (provider.campTypes.isEmpty) {
        provider.loadCampTypes();
      }
    });
  }

  void _showCampTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer<CampProvider>(
          builder: (context, prov, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Chọn loại trại hè",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: prov.campTypes.length,
                      itemBuilder: (context, index) {
                        final type = prov.campTypes[index];
                        final isSelected =
                            prov.selectedCampTypeId == type.campTypeId;

                        return ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? AppTheme.summerAccent
                                : Colors.grey,
                          ),
                          title: Text(
                            type.name,
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.summerAccent
                                  : Colors.black87,
                            ),
                          ),
                          onTap: () {
                            prov.selectCampType(type.campTypeId);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  if (prov.selectedCampTypeId != null)
                    ListTile(
                      leading: const Icon(Icons.clear, color: Colors.red),
                      title: const Text(
                        "Bỏ lọc loại trại",
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        prov.selectCampType(null);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampProvider>();
    final textTheme = Theme.of(context).textTheme;
    final displayCamps = provider.filteredCamps;

    String typeLabel = "Loại";
    if (provider.selectedCampTypeId != null) {
      final selectedType = provider.campTypes.firstWhere(
        (t) => t.campTypeId == provider.selectedCampTypeId,
      );
      if (selectedType.name.isNotEmpty) {
        typeLabel = selectedType.name;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Danh sách trại hè",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppTheme.summerPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF5F7F8),
      ),
      backgroundColor: Color(0xFFF5F7F8),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip(
                  label: "Tất cả",
                  isSelected:
                      provider.selectedCampTypeId == null &&
                      !provider.isUpcomingSelected,
                  onTap: () => provider.selectCampType(null),
                ),
                const SizedBox(width: 8),

                _buildFilterChip(
                  label: "Sắp diễn ra",
                  isSelected: provider.isUpcomingSelected,
                  icon: Icons.access_time,
                  onTap: () => provider.toggleUpcoming(),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: typeLabel,
                  isSelected: provider.selectedCampTypeId != null,
                  icon: Icons.filter_list_alt,
                  onTap: () => _showCampTypeSelector(context),
                  showDropdownIcon: true,
                ),
              ],
            ),
          ),

          Expanded(
            child: provider.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.summerPrimary,
                    ),
                  )
                : displayCamps.isEmpty
                ? Center(
                    child: Text(
                      "Không tìm thấy trại hè phù hợp",
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: "Quicksand",
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayCamps.length,
                    itemBuilder: (context, index) {
                      return CampCard(camp: displayCamps[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    bool showDropdownIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF01579B) : const Color(0xFFE1F5FE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.summerAccent,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : const Color(0xFF01579B),
              ),
            ),
            if (showDropdownIcon) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF01579B),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
