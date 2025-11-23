// import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
// import 'package:dat_san_247_mobile/core/utils/extensions/widget_ext.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_search_history.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_venue.dart';
// import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';
// import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_header.dart';
// import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_box_with_filter.dart';
// import 'package:dat_san_247_mobile/features/search_venue/presentation/widgets/search_result_list.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final venueController = Get.find<VenueController>();
//   final TextEditingController searchController = TextEditingController();
//   final FocusNode searchFocusNode = FocusNode();

//   // Bộ lọc mẫu
//   String? selectedType;
//   String? selectedDistrict;
//   bool showHistory = false;

//   @override
//   void initState() {
//     super.initState();
//     searchFocusNode.addListener(() {
//       setState(() {
//         showHistory = searchFocusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     searchFocusNode.dispose();
//     super.dispose();
//   }

//   void _showFilterSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         String? tempType = selectedType;
//         String? tempDistrict = selectedDistrict;
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Bộ lọc",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 18),
//                   DropdownButtonFormField<String>(
//                     value: tempType,
//                     decoration: InputDecoration(
//                       labelText: "Loại sân",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     items: [
//                       DropdownMenuItem(value: null, child: Text("Tất cả")),
//                       DropdownMenuItem(
//                         value: "Bóng đá",
//                         child: Text("Bóng đá"),
//                       ),
//                       DropdownMenuItem(value: "Tennis", child: Text("Tennis")),
//                       DropdownMenuItem(
//                         value: "Cầu lông",
//                         child: Text("Cầu lông"),
//                       ),
//                     ],
//                     onChanged: (value) => setModalState(() => tempType = value),
//                   ),
//                   SizedBox(height: 14),
//                   DropdownButtonFormField<String>(
//                     value: tempDistrict,
//                     decoration: InputDecoration(
//                       labelText: "Quận",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     items: [
//                       DropdownMenuItem(value: null, child: Text("Tất cả")),
//                       DropdownMenuItem(value: "Quận 1", child: Text("Quận 1")),
//                       DropdownMenuItem(value: "Quận 7", child: Text("Quận 7")),
//                       DropdownMenuItem(
//                         value: "Quận 10",
//                         child: Text("Quận 10"),
//                       ),
//                     ],
//                     onChanged: (value) =>
//                         setModalState(() => tempDistrict = value),
//                   ),
//                   SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff62b766),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                       ),
//                       child: Text(
//                         "Lọc",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           selectedType = tempType;
//                           selectedDistrict = tempDistrict;
//                         });
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xff62b766).withOpacity(0.12),
//               Colors.white,
//               Color(0xff4fa553).withOpacity(0.06),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 14,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SearchHeader(),
//                       const SizedBox(height: 24),
//                       SearchBoxWithFilter(
//                         searchController: searchController,
//                         searchFocusNode: searchFocusNode,
//                         onFilterTap: _showFilterSheet,
//                         onChanged: (value) {
//                           setState(() {}); // Mỗi lần nhập sẽ lọc lại kết quả
//                         },
//                       ),
//                       const SizedBox(height: 18),
//                       Text(
//                         "Kết quả tìm kiếm",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xff2d5533),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       SearchResultList(
//                         selectedType: selectedType,
//                         selectedDistrict: selectedDistrict,
//                         searchController: searchController,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Lịch sử tìm kiếm chỉ hiện khi focus vào ô tìm kiếm
//               if (showHistory)
//                 Positioned(
//                   top: 135,
//                   left: 18,
//                   right: 18,
//                   child: Material(
//                     elevation: 6,
//                     borderRadius: BorderRadius.circular(18),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xff62b766).withOpacity(0.10),
//                             blurRadius: 12,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 8,
//                         ),
//                         child: ListSearchHistory(
//                           onSelect: (keyword) {
//                             searchController.text = keyword;
//                             setState(() {
//                               showHistory = false;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchBarAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Search state
  String searchQuery = '';
  bool isSearching = false;
  bool showSearchHistory = false;
  bool isLoading = false;
  String selectedLocation = 'Hà Nội';
  String selectedSortBy = 'Gần nhất';

  // Filter state
  Set<String> selectedCategories = {};
  RangeValues priceRange = const RangeValues(50000, 500000);
  double minRating = 0.0;
  double maxDistance = 10.0;

  // Data
  List<String> searchHistory = [
    'Sân bóng Mỹ Đình',
    'Sân cầu lông Thanh Xuân',
    'Sân tennis gần đây',
    'Sân bóng rổ Hà Nội',
    'Swimming pool',
  ];

  List<String> popularSearches = [
    'Sân bóng đá 11 người',
    'Sân cầu lông có điều hòa',
    'Sân tennis outdoor',
    'Bể bơi 4 mùa',
    'Sân bóng rổ indoor',
    'Sân futsal',
  ];

  List<SportCategoryModel> categories = [
    SportCategoryModel(
      id: '1',
      name: 'Bóng đá',
      icon: Icons.sports_soccer,
      color: Colors.green,
      count: 125,
    ),
    SportCategoryModel(
      id: '2',
      name: 'Cầu lông',
      icon: Icons.sports_tennis,
      color: Colors.blue,
      count: 89,
    ),
    SportCategoryModel(
      id: '3',
      name: 'Bóng rổ',
      icon: Icons.sports_basketball,
      color: Colors.orange,
      count: 67,
    ),
    SportCategoryModel(
      id: '4',
      name: 'Tennis',
      icon: Icons.sports_tennis,
      color: Colors.purple,
      count: 45,
    ),
    SportCategoryModel(
      id: '5',
      name: 'Bơi lội',
      icon: Icons.pool,
      color: Colors.cyan,
      count: 32,
    ),
    SportCategoryModel(
      id: '6',
      name: 'Gym',
      icon: Icons.fitness_center,
      color: Colors.red,
      count: 28,
    ),
  ];

  List<VenueSearchResult> searchResults = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupSearchListener();
    _loadMockData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _searchBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchAnimationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _searchAnimationController.forward();
  }

  void _setupSearchListener() {
    _searchFocusNode.addListener(() {
      setState(() {
        showSearchHistory = _searchFocusNode.hasFocus && searchQuery.isEmpty;
      });
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      setState(() {
        searchQuery = query;
        isSearching = query.isNotEmpty;
        showSearchHistory = query.isEmpty && _searchFocusNode.hasFocus;
      });

      if (query.isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  void _loadMockData() {
    searchResults = [
      VenueSearchResult(
        id: '1',
        name: 'Sân bóng Mỹ Đình Sport Center',
        address: 'Từ Liêm, Hà Nội',
        category: 'Bóng đá',
        price: 200000,
        rating: 4.8,
        reviewCount: 156,
        distance: 2.1,
        imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
        amenities: ['Parking', 'Shower', 'Cafe'],
        openTime: '06:00 - 22:00',
        isOpen: true,
      ),
      VenueSearchResult(
        id: '2',
        name: 'Sân cầu lông Thanh Xuân Premium',
        address: 'Thanh Xuân, Hà Nội',
        category: 'Cầu lông',
        price: 80000,
        rating: 4.6,
        reviewCount: 89,
        distance: 1.5,
        imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        amenities: ['AC', 'Shower', 'Equipment'],
        openTime: '05:00 - 23:00',
        isOpen: true,
      ),
      VenueSearchResult(
        id: '3',
        name: 'Tennis Club Hoàng Mai',
        address: 'Hoàng Mai, Hà Nội',
        category: 'Tennis',
        price: 150000,
        rating: 4.7,
        reviewCount: 134,
        distance: 3.2,
        imageUrl: 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=400',
        amenities: ['Outdoor', 'Professional', 'Coaching'],
        openTime: '06:00 - 21:00',
        isOpen: false,
      ),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Column(
              children: [
                // Header with search bar
                _buildHeader(theme),
                
                // Content area
                Expanded(
                  child: _buildContent(theme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          AnimatedBuilder(
            animation: _searchBarAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * _searchBarAnimation.value),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _searchFocusNode.hasFocus 
                          ? theme.primaryColor 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      // Search field
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Tìm sân thể thao...',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 16),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _addToSearchHistory(value);
                              _performSearch(value);
                            }
                          },
                        ),
                      ),
                      
                      // Voice search button
                      IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: theme.primaryColor,
                        ),
                        onPressed: _startVoiceSearch,
                      ),
                      
                      // Clear button
                      if (searchQuery.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                              isSearching = false;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Location and sort options
          if (!showSearchHistory) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                // Location selector
                Expanded(
                  child: InkWell(
                    onTap: _showLocationPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: theme.primaryColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              selectedLocation,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.expand_more, size: 16, color: theme.primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Sort selector
                InkWell(
                  onTap: _showSortOptions,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 16, color: Colors.grey[700]),
                        const SizedBox(width: 4),
                        Text(
                          selectedSortBy,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Filter button
                InkWell(
                  onTap: _showFilterDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedCategories.isNotEmpty 
                          ? theme.primaryColor 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20,
                      color: selectedCategories.isNotEmpty 
                          ? Colors.white 
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (showSearchHistory) {
      return _buildSearchHistory(theme);
    } else if (isLoading) {
      return _buildLoadingState(theme);
    } else if (searchQuery.isEmpty) {
      return _buildInitialState(theme);
    } else {
      return _buildSearchResults(theme);
    }
  }

  Widget _buildSearchHistory(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tìm kiếm gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: _clearSearchHistory,
                  child: Text(
                    'Xóa tất cả',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...searchHistory.map((search) => _buildHistoryItem(search, theme)),
            
            const SizedBox(height: 24),
          ],
          
          // Popular searches
          const Text(
            'Tìm kiếm phổ biến',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return InkWell(
                onTap: () {
                  _searchController.text = search;
                  _addToSearchHistory(search);
                  _performSearch(search);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        search,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String search, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _searchController.text = search;
          _performSearch(search);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.grey[500],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  search,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeFromHistory(search),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[400],
                  size: 18,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          const Text(
            'Loại sân thể thao',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(category, theme);
            },
          ),
          
          const SizedBox(height: 32),
          
          // Quick access section
          const Text(
            'Truy cập nhanh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildQuickAccessCard(
            'Sân gần tôi',
            'Tìm sân trong bán kính 5km',
            Icons.near_me,
            Colors.blue,
            () => _searchNearbyVenues(),
          ),
          
          const SizedBox(height: 12),
          
          _buildQuickAccessCard(
            'Sân đang khuyến mãi',
            'Ưu đãi và giảm giá hấp dẫn',
            Icons.local_offer,
            Colors.orange,
            () => _searchPromotionalVenues(),
          ),
          
          const SizedBox(height: 12),
          
          _buildQuickAccessCard(
            'Sân cao cấp',
            'Sân với rating từ 4.5 sao trở lên',
            Icons.star,
            Colors.amber,
            () => _searchPremiumVenues(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(SportCategoryModel category, ThemeData theme) {
    return InkWell(
      onTap: () => _searchByCategory(category),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    category.color,
                    category.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: category.color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              '${category.count} sân',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Đang tìm kiếm...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (searchResults.isEmpty) {
      return _buildNoResults(theme);
    }

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tìm thấy ${searchResults.length} kết quả',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Show on map
                },
                icon: const Icon(Icons.map, size: 18),
                label: const Text('Bản đồ'),
              ),
            ],
          ),
        ),
        
        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final venue = searchResults[index];
              return _buildVenueCard(venue, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVenueCard(VenueSearchResult venue, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to venue details
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    venue.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                    ),
                  ),
                ),
                
                // Distance badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${venue.distance} km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Open/Closed badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: venue.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      venue.isOpen ? 'Đang mở' : 'Đã đóng',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Favorite button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Toggle favorite
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            
            // Venue info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          venue.category,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        venue.openTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${venue.rating}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${venue.reviewCount} đánh giá)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${NumberFormat('#,##0').format(venue.price)}đ/h',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Amenities
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: venue.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // View details
                          },
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('Chi tiết'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Book now
                          },
                          icon: const Icon(Icons.book_online, size: 18),
                          label: const Text('Đặt sân'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.search_off,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Thử tìm kiếm với từ khóa khác hoặc điều chỉnh bộ lọc',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: _showFilterDialog,
              icon: const Icon(Icons.tune),
              label: const Text('Điều chỉnh bộ lọc'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _performSearch(String query) {
    setState(() {
      isLoading = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          // Filter results based on query
          // In real app, this would be an API call
        });
      }
    });
  }

  void _addToSearchHistory(String query) {
    setState(() {
      searchHistory.remove(query); // Remove if exists
      searchHistory.insert(0, query); // Add to beginning
      if (searchHistory.length > 10) {
        searchHistory.removeLast(); // Keep only 10 items
      }
    });
  }

  void _removeFromHistory(String query) {
    setState(() {
      searchHistory.remove(query);
    });
  }

  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  void _startVoiceSearch() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tính năng tìm kiếm bằng giọng nói đang được phát triển'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Chọn thành phố',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...['Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ'].map(
              (city) => ListTile(
                title: Text(city),
                trailing: selectedLocation == city ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    selectedLocation = city;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    final sortOptions = ['Gần nhất', 'Giá thấp nhất', 'Giá cao nhất', 'Đánh giá cao'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Sắp xếp theo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...sortOptions.map(
              (option) => ListTile(
                title: Text(option),
                trailing: selectedSortBy == option ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    selectedSortBy = option;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategories.clear();
                        priceRange = const RangeValues(50000, 500000);
                        minRating = 0.0;
                        maxDistance = 10.0;
                      });
                    },
                    child: const Text('Đặt lại'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category filter
                    const Text(
                      'Loại sân',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = selectedCategories.contains(category.id);
                        return FilterChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(category.id);
                              } else {
                                selectedCategories.remove(category.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Price range
                    const Text(
                      'Khoảng giá (VNĐ/giờ)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: priceRange,
                      min: 20000,
                      max: 1000000,
                      divisions: 20,
                      labels: RangeLabels(
                        NumberFormat('#,##0').format(priceRange.start),
                        NumberFormat('#,##0').format(priceRange.end),
                      ),
                      onChanged: (values) {
                        setState(() {
                          priceRange = values;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Rating filter
                    const Text(
                      'Đánh giá tối thiểu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: minRating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      label: '${minRating.toStringAsFixed(1)} sao',
                      onChanged: (value) {
                        setState(() {
                          minRating = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Distance filter
                    const Text(
                      'Khoảng cách tối đa (km)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: maxDistance,
                      min: 1.0,
                      max: 50.0,
                      divisions: 49,
                      label: '${maxDistance.toStringAsFixed(0)} km',
                      onChanged: (value) {
                        setState(() {
                          maxDistance = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Áp dụng bộ lọc',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchByCategory(SportCategoryModel category) {
    _searchController.text = category.name;
    _addToSearchHistory(category.name);
    _performSearch(category.name);
  }

  void _searchNearbyVenues() {
    _searchController.text = 'sân gần tôi';
    _addToSearchHistory('sân gần tôi');
    _performSearch('sân gần tôi');
  }

  void _searchPromotionalVenues() {
    _searchController.text = 'sân khuyến mãi';
    _addToSearchHistory('sân khuyến mãi');
    _performSearch('sân khuyến mãi');
  }

  void _searchPremiumVenues() {
    _searchController.text = 'sân cao cấp';
    _addToSearchHistory('sân cao cấp');
    _performSearch('sân cao cấp');
  }

  void _applyFilters() {
    // Apply current filters to search results
    _performSearch(searchQuery);
  }
}

// Model classes
class SportCategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int count;

  SportCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
  });
}

class VenueSearchResult {
  final String id;
  final String name;
  final String address;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final double distance;
  final String imageUrl;
  final List<String> amenities;
  final String openTime;
  final bool isOpen;

  VenueSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageUrl,
    required this.amenities,
    required this.openTime,
    required this.isOpen,
  });
}