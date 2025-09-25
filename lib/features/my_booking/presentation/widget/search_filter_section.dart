import 'package:flutter/material.dart';

class SearchFilterSection extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedStatus;
  final Function(String?) onStatusChanged;
  final VoidCallback onSearchChanged;

  const SearchFilterSection({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) => onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sân...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[400]),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                icon: Icon(Icons.expand_more, color: theme.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                borderRadius: BorderRadius.circular(16),
                items: [
                  'Tất cả',
                  'Đã xác nhận',
                  'Chờ xác nhận',
                  'Đã hoàn thành',
                  'Đã hủy',
                ].map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                )).toList(),
                onChanged: onStatusChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}