import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/widget_ext.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_search_history.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_venue.dart';
import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';
import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_header.dart';
import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_box_with_filter.dart';
import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final venueController = Get.find<VenueController>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Bộ lọc mẫu
  String? selectedType;
  String? selectedDistrict;
  bool showHistory = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        showHistory = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String? tempType = selectedType;
        String? tempDistrict = selectedDistrict;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bộ lọc",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    value: tempType,
                    decoration: InputDecoration(
                      labelText: "Loại sân",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text("Tất cả")),
                      DropdownMenuItem(
                        value: "Bóng đá",
                        child: Text("Bóng đá"),
                      ),
                      DropdownMenuItem(value: "Tennis", child: Text("Tennis")),
                      DropdownMenuItem(
                        value: "Cầu lông",
                        child: Text("Cầu lông"),
                      ),
                    ],
                    onChanged: (value) => setModalState(() => tempType = value),
                  ),
                  SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: tempDistrict,
                    decoration: InputDecoration(
                      labelText: "Quận",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text("Tất cả")),
                      DropdownMenuItem(value: "Quận 1", child: Text("Quận 1")),
                      DropdownMenuItem(value: "Quận 7", child: Text("Quận 7")),
                      DropdownMenuItem(
                        value: "Quận 10",
                        child: Text("Quận 10"),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempDistrict = value),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff62b766),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Lọc",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedType = tempType;
                          selectedDistrict = tempDistrict;
                        });
                        Navigator.pop(context);
                      },
                    ),
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff62b766).withOpacity(0.12),
              Colors.white,
              Color(0xff4fa553).withOpacity(0.06),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SearchHeader(),
                      const SizedBox(height: 24),
                      SearchBoxWithFilter(
                        searchController: searchController,
                        searchFocusNode: searchFocusNode,
                        onFilterTap: _showFilterSheet,
                        onChanged: (value) {
                          setState(() {}); // Mỗi lần nhập sẽ lọc lại kết quả
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Kết quả tìm kiếm",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2d5533),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SearchResultList(
                        selectedType: selectedType,
                        selectedDistrict: selectedDistrict,
                        searchController: searchController,
                      ),
                    ],
                  ),
                ),
              ),
              // Lịch sử tìm kiếm chỉ hiện khi focus vào ô tìm kiếm
              if (showHistory)
                Positioned(
                  top: 135,
                  left: 18,
                  right: 18,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff62b766).withOpacity(0.10),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: ListSearchHistory(
                          onSelect: (keyword) {
                            searchController.text = keyword;
                            setState(() {
                              showHistory = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
