import 'package:flutter/material.dart';

class SearchBoxWithFilter extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged; // Thêm dòng này

  const SearchBoxWithFilter({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.onFilterTap,
    this.onChanged, // Thêm dòng này
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff62b766).withOpacity(0.10),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: onChanged, // Thêm dòng này
              decoration: InputDecoration(
                hintText: 'Nhập tên sân, địa chỉ...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Color(0xff62b766)),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, color: Color(0xff62b766)),
                        onPressed: () {
                          searchController.clear();
                          if (onChanged != null) onChanged!("");
                        },
                      ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onFilterTap,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff62b766), Color(0xff4fa553)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff62b766).withOpacity(0.12),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.filter_alt, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}