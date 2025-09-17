import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/widget_ext.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_search_history.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_venue.dart';
import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff62b766), Color(0xff4fa553)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Tìm kiếm sân",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2d5533),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Search box + Filter button
                      Row(
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
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Nhập tên sân, địa chỉ...',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff62b766),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 18,
                                  ),
                                  suffixIcon: searchController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Color(0xff62b766),
                                          ),
                                          onPressed: () {
                                            searchController.clear();
                                            setState(() {});
                                          },
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bộ lọc",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 18),
                                            DropdownButtonFormField<String>(
                                              value: tempType,
                                              decoration: InputDecoration(
                                                labelText: "Loại sân",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: null,
                                                  child: Text("Tất cả"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Bóng đá",
                                                  child: Text("Bóng đá"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Tennis",
                                                  child: Text("Tennis"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Cầu lông",
                                                  child: Text("Cầu lông"),
                                                ),
                                              ],
                                              onChanged: (value) =>
                                                  setModalState(
                                                    () => tempType = value,
                                                  ),
                                            ),
                                            SizedBox(height: 14),
                                            DropdownButtonFormField<String>(
                                              value: tempDistrict,
                                              decoration: InputDecoration(
                                                labelText: "Quận",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value: null,
                                                  child: Text("Tất cả"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Quận 1",
                                                  child: Text("Quận 1"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Quận 7",
                                                  child: Text("Quận 7"),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Quận 10",
                                                  child: Text("Quận 10"),
                                                ),
                                              ],
                                              onChanged: (value) =>
                                                  setModalState(
                                                    () => tempDistrict = value,
                                                  ),
                                            ),
                                            SizedBox(height: 24),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xff62b766,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Lọc",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedType = tempType;
                                                    selectedDistrict =
                                                        tempDistrict;
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
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff62b766),
                                    Color(0xff4fa553),
                                  ],
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
                              child: Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),

                      // Result list
                      Text(
                        "Kết quả tìm kiếm",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2d5533),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          child: Obx(() {
                            // Lọc dữ liệu theo bộ lọc
                            final filteredVenues = venueController.listVenue
                                .where((venue) {
                                  final matchesType = selectedType == null;
                                  final matchesDistrict =
                                      selectedDistrict == null;
                                  final matchesSearch =
                                      searchController.text.isEmpty ||
                                      (venue.venueName ?? '')
                                          .toLowerCase()
                                          .contains(
                                            searchController.text.toLowerCase(),
                                          );
                                  return matchesType &&
                                      matchesDistrict &&
                                      matchesSearch;
                                })
                                .toList();

                            if (filteredVenues.isEmpty) {
                              return Center(
                                child: Text("Không có kết quả phù hợp"),
                              );
                            }
                            return ListVenue(venues: filteredVenues);
                          }),
                        ),
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
