// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   late MapController controller;
//   GeoPoint? selectedPoint;
//   String address = "";

//   @override
//   void initState() {
//     super.initState();
//     controller = MapController(
//       initPosition: GeoPoint(latitude: 10.762622, longitude: 106.660172),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<void> _requestLocationPermission() async {
//     final status = await Permission.location.request();
//     if (!status.isGranted) {
//       if (mounted) {
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text("Yêu cầu quyền vị trí"),
//             content: const Text("Bạn cần cấp quyền vị trí để xác định vị trí của bạn."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: const Text("Đóng"),
//               ),
//               TextButton(
//                 onPressed: () => openAppSettings(),
//                 child: const Text("Cài đặt"),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       await _requestLocationPermission();
//       final position = await controller.myLocation();
//       if (position != null) {
//         await controller.goToLocation(position);
//         await _onMapTap(position);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Không thể lấy vị trí hiện tại: $e")),
//         );
//       }
//     }
//   }

//   Future<void> _onMapTap(GeoPoint point) async {
//     try {
//       // Xóa marker cũ nếu có
//       if (selectedPoint != null) {
//         await controller.removeMarker(selectedPoint!);
//       }

//       setState(() {
//         selectedPoint = point;
//         address = "Vị trí đã chọn: Lat: ${point.latitude.toStringAsFixed(6)}, Lng: ${point.longitude.toStringAsFixed(6)}";
//       });

//       // Thêm marker mới
//       await controller.addMarker(
//         point,
//         markerIcon: const MarkerIcon(
//           icon: Icon(Icons.location_on, color: Colors.red, size: 48),
//         ),
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi khi thêm marker: $e")),
//         );
//       }
//     }
//   }

//   void _clearSelection() async {
//     if (selectedPoint != null) {
//       try {
//         await controller.removeMarker(selectedPoint!);
//         setState(() {
//           selectedPoint = null;
//           address = "";
//         });
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Lỗi khi xóa marker: $e")),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               const Color(0xff62b766).withOpacity(0.12),
//               Colors.white,
//               const Color(0xff4fa553).withOpacity(0.06),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   children: [
//                     Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xff62b766), Color(0xff4fa553)],
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xff62b766).withOpacity(0.18),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(Icons.map, color: Colors.white, size: 20),
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         "Chọn vị trí trên bản đồ",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff2d5533),
//                         ),
//                       ),
//                     ),
//                     // Nút lấy vị trí hiện tại
//                     IconButton(
//                       onPressed: _getCurrentLocation,
//                       icon: const Icon(Icons.my_location),
//                       style: IconButton.styleFrom(
//                         backgroundColor: const Color(0xff62b766),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.all(8),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 18),

//                 // Card chứa bản đồ
//                 Expanded(
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: OSMFlutter(
//                         controller: controller,
//                         osmOption: OSMOption(
//                           userLocationMarker: UserLocationMaker(
//                             personMarker: const MarkerIcon(
//                               icon: Icon(Icons.location_history_rounded,
//                                 color: Colors.red,
//                                 size: 48,
//                               ),
//                             ),
//                             directionArrowMarker: const MarkerIcon(
//                               icon: Icon(Icons.double_arrow,
//                                 size: 48,
//                               ),
//                             ),
//                           ),
//                           zoomOption: const ZoomOption(
//                             minZoomLevel: 3,
//                             maxZoomLevel: 18,
//                             initZoom: 14,
//                           ),
//                           userTrackingOption: const UserTrackingOption(
//                             enableTracking: false,
//                             unFollowUser: false,
//                           ),
//                         ),
//                         mapIsLoading: const Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: Color(0xff62b766),
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 "Đang tải bản đồ...",
//                                 style: TextStyle(
//                                   color: Color(0xff2d5533),
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         onGeoPointClicked: (geoPoint) async {
//                           await _onMapTap(geoPoint);
//                         },
//                         onMapIsReady: (ready) {
//                           if (ready && mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Bản đồ đã sẵn sàng! Chạm vào bản đồ để chọn vị trí."),
//                                 duration: Duration(seconds: 2),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),

//                 // Hiển thị địa chỉ đã chọn
//                 if (address.isNotEmpty)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xff62b766).withOpacity(0.08),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.location_on, color: Color(0xff62b766)),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             address,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               color: Color(0xff2d5533),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         // Nút xóa selection
//                         IconButton(
//                           onPressed: _clearSelection,
//                           icon: const Icon(Icons.clear),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.red.withOpacity(0.1),
//                             foregroundColor: Colors.red,
//                             padding: const EdgeInsets.all(4),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Nút xác nhận (nếu cần)
//                 if (selectedPoint != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Xử lý khi người dùng xác nhận vị trí
//                           Navigator.pop(context, selectedPoint);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xff62b766),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: const Text(
//                           "Xác nhận vị trí",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                 // Hướng dẫn sử dụng
//                 if (selectedPoint == null)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xff62b766).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: const Color(0xff62b766).withOpacity(0.3),
//                       ),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.info_outline, color: Color(0xff62b766)),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "Chạm vào bản đồ để chọn vị trí hoặc nhấn biểu tượng GPS để lấy vị trí hiện tại",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xff2d5533),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math' show pi, pow, sin, cos, sqrt, atan2; // Thêm dòng này

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late MapController controller;
  late AnimationController _searchAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _searchAnimation;
  late Animation<double> _fabAnimation;

  // Map state
  GeoPoint? selectedPoint;
  GeoPoint? currentLocation;
  String searchQuery = "";
  bool isSearching = false;
  bool isLoadingLocation = false;
  bool showSearchResults = false;
  bool isFollowingUser = false;
  MapLayer currentLayer = MapLayer.standard;

  // Search and filter state
  List<SearchResult> searchResults = [];
  List<VenueMarker> venues = [];
  Set<String> selectedCategories = {};
  double searchRadius = 5000; // meters
  bool showTrafficLayer = false;

  // UI state
  bool showBottomSheet = false;
  bool showLayerSelector = false;
  VenueMarker? selectedVenue;

  bool _isMapReady = false; // Thêm biến này

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _setupAnimations();
    _setSystemUI();
    _loadMockVenues(); // Vẫn load data nhưng chưa add markers
  }

  void _initializeMap() {
    controller = MapController(
      initPosition: GeoPoint(latitude: 21.0285, longitude: 105.8542), // Hanoi
    );
  }

  void _setupAnimations() {
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _fabAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _searchAnimationController.forward();
    _fabAnimationController.forward();
  }

  void _setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _loadMockVenues() {
    // Chỉ load data, không thêm markers
    venues = [
      VenueMarker(
        id: '1',
        name: 'Sân bóng Mỹ Đình',
        category: 'Football',
        position: GeoPoint(latitude: 21.0285, longitude: 105.8542),
        rating: 4.8,
        price: '200,000đ/h',
        imageUrl: 'https://example.com/image1.jpg',
      ),
      VenueMarker(
        id: '2',
        name: 'Sân cầu lông Thanh Xuân',
        category: 'Badminton',
        position: GeoPoint(latitude: 21.0145, longitude: 105.8372),
        rating: 4.6,
        price: '80,000đ/h',
        imageUrl: 'https://example.com/image2.jpg',
      ),
      // Add more mock venues...
    ];
  }

  Future<void> _addVenueMarkers() async {
    if (!_isMapReady) return; // Kiểm tra map đã sẵn sàng chưa

    for (var venue in venues) {
      try {
        await controller.addMarker(
          venue.position,
          markerIcon: MarkerIcon(
            iconWidget: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(venue.category),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(venue.category),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      } catch (e) {
        print('Error adding marker for ${venue.name}: $e');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopUI(),
          if (showSearchResults) _buildSearchResults(),
          if (showBottomSheet) _buildVenueBottomSheet(),
          if (showLayerSelector) _buildLayerSelector(),
          _buildFloatingActions(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(Icons.my_location, color: Colors.blue, size: 48),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(Icons.navigation, color: Colors.blue, size: 48),
          ),
        ),
        zoomOption: const ZoomOption(
          minZoomLevel: 3,
          maxZoomLevel: 19,
          initZoom: 14,
        ),
        userTrackingOption: UserTrackingOption(
          enableTracking: isFollowingUser,
          unFollowUser: !isFollowingUser,
        ),
      ),
      mapIsLoading: Container(
        color: Colors.grey[100],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tải bản đồ...'),
            ],
          ),
        ),
      ),
      onGeoPointClicked: _onMapTap,
      onMapIsReady: (ready) {
        if (ready) {
          setState(() => _isMapReady = true);
          _initMapFeatures(); // Khởi tạo các tính năng map
        }
      },
    );
  }

  void _initMapFeatures() async {
    if (!_isMapReady) return;

    try {
      await _addVenueMarkers();
      await _getCurrentLocation();
    } catch (e) {
      print('Error initializing map features: $e');
    }
  }

  Widget _buildTopUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            AnimatedBuilder(
              animation: _searchAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - _searchAnimation.value)),
                  child: Opacity(
                    opacity: _searchAnimation.value,
                    child: _buildSearchBar(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Filter chips
            if (isSearching) _buildFilterChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu/Back button
          IconButton(
            icon: Icon(isSearching ? Icons.arrow_back : Icons.menu),
            onPressed: () {
              if (isSearching) {
                setState(() {
                  isSearching = false;
                  showSearchResults = false;
                  searchQuery = "";
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),

          // Search field
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  isSearching = value.isNotEmpty;
                });
                if (value.isNotEmpty) {
                  _performSearch(value);
                } else {
                  setState(() {
                    showSearchResults = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: isSearching
                    ? 'Tìm kiếm sân thể thao...'
                    : 'Tìm kiếm địa điểm',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),

          // Voice search
          IconButton(icon: const Icon(Icons.mic), onPressed: _startVoiceSearch),

          // Clear/Search button
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  searchQuery = "";
                  isSearching = false;
                  showSearchResults = false;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final categories = [
      'Football',
      'Badminton',
      'Basketball',
      'Tennis',
      'Swimming',
    ];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((category) {
          final isSelected = selectedCategories.contains(category);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                  _filterVenues();
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Positioned(
      top: 120,
      left: 16,
      right: 16,
      bottom: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final result = searchResults[index];
            return _buildSearchResultItem(result);
          },
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(SearchResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            result.type == 'venue' ? Icons.sports_soccer : Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          result.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.address),
            if (result.type == 'venue')
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(' ${result.rating}'),
                  const SizedBox(width: 8),
                  Text(result.price),
                ],
              ),
          ],
        ),
        trailing: Text(
          '${result.distance.toStringAsFixed(1)} km',
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: () => _selectSearchResult(result),
      ),
    );
  }

  Widget _buildVenueBottomSheet() {
    if (selectedVenue == null) return const SizedBox();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
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
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Venue details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedVenue!.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showBottomSheet = false;
                            selectedVenue = null;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 20),
                      Text(' ${selectedVenue!.rating}'),
                      const SizedBox(width: 16),
                      Icon(Icons.attach_money, color: Colors.green, size: 20),
                      Text(selectedVenue!.price),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to venue details
                          },
                          icon: const Icon(Icons.info),
                          label: const Text('Chi tiết'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to booking
                          },
                          icon: const Icon(Icons.book_online),
                          label: const Text('Đặt sân'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.directions,
                        label: 'Chỉ đường',
                        onPressed: _getDirections,
                      ),
                      _buildActionButton(
                        icon: Icons.phone,
                        label: 'Gọi điện',
                        onPressed: _makeCall,
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'Chia sẻ',
                        onPressed: _shareLocation,
                      ),
                      _buildActionButton(
                        icon: Icons.favorite_border,
                        label: 'Yêu thích',
                        onPressed: _toggleFavorite,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[100],
            foregroundColor: Colors.grey[700],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLayerSelector() {
    return Positioned(
      top: 100,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MapLayer.values.map((layer) {
            return ListTile(
              dense: true,
              leading: Icon(_getLayerIcon(layer)),
              title: Text(_getLayerName(layer)),
              selected: currentLayer == layer,
              onTap: () {
                setState(() {
                  currentLayer = layer;
                  showLayerSelector = false;
                });
                _changeMapLayer(layer);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFloatingActions() {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),

          // Right side buttons
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  // Layer selector button
                  FloatingActionButton.small(
                    onPressed: () {
                      setState(() {
                        showLayerSelector = !showLayerSelector;
                      });
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    child: const Icon(Icons.layers),
                  ),

                  const SizedBox(height: 8),

                  // My location button
                  FloatingActionButton.small(
                    onPressed: _getCurrentLocation,
                    backgroundColor: Colors.white,
                    foregroundColor: isLoadingLocation
                        ? Colors.grey
                        : Colors.blue,
                    child: isLoadingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                  ),

                  const SizedBox(height: 8),

                  // Zoom in
                  FloatingActionButton.small(
                    onPressed: () => controller.zoomIn(),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    child: const Icon(Icons.add),
                  ),

                  const SizedBox(height: 8),

                  // Zoom out
                  FloatingActionButton.small(
                    onPressed: () => controller.zoomOut(),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper methods
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Football':
        return Colors.green;
      case 'Badminton':
        return Colors.blue;
      case 'Basketball':
        return Colors.orange;
      case 'Tennis':
        return Colors.purple;
      case 'Swimming':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Football':
        return Icons.sports_soccer;
      case 'Badminton':
        return Icons.sports_tennis;
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Tennis':
        return Icons.sports_tennis;
      case 'Swimming':
        return Icons.pool;
      default:
        return Icons.place;
    }
  }

  IconData _getLayerIcon(MapLayer layer) {
    switch (layer) {
      case MapLayer.standard:
        return Icons.map;
      case MapLayer.satellite:
        return Icons.satellite;
      case MapLayer.terrain:
        return Icons.terrain;
      case MapLayer.hybrid:
        return Icons.layers;
    }
  }

  String _getLayerName(MapLayer layer) {
    switch (layer) {
      case MapLayer.standard:
        return 'Bản đồ';
      case MapLayer.satellite:
        return 'Vệ tinh';
      case MapLayer.terrain:
        return 'Địa hình';
      case MapLayer.hybrid:
        return 'Kết hợp';
    }
  }

  // Action methods
  Future<void> _getCurrentLocation() async {
    if (!mounted || !_isMapReady) return;

    setState(() => isLoadingLocation = true);

    try {
      final status = await Permission.location.request();
      if (status.isGranted && mounted) {
        final position = await controller.myLocation();
        if (position != null && mounted) {
          setState(() {
            currentLocation = position;
            isFollowingUser = true;
          });
          await controller.goToLocation(position);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Không thể lấy vị trí hiện tại: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingLocation = false);
      }
    }
  }

  void _performSearch(String query) {
    // Mock search implementation
    setState(() {
      searchResults = [
        SearchResult(
          name: 'Sân bóng Mỹ Đình',
          address: 'Nam Từ Liêm, Hà Nội',
          type: 'venue',
          position: GeoPoint(latitude: 21.0285, longitude: 105.8542),
          rating: 4.8,
          price: '200,000đ/h',
          distance: 2.1,
        ),
        SearchResult(
          name: 'Sân cầu lông Thanh Xuân',
          address: 'Thanh Xuân, Hà Nội',
          type: 'venue',
          position: GeoPoint(latitude: 21.0145, longitude: 105.8372),
          rating: 4.6,
          price: '80,000đ/h',
          distance: 1.5,
        ),
      ];
      showSearchResults = true;
    });
  }

  void _filterVenues() {
    // Implement venue filtering logic
  }

  void _selectSearchResult(SearchResult result) {
    controller.goToLocation(result.position);
    setState(() {
      showSearchResults = false;
      if (result.type == 'venue') {
        selectedVenue = venues.firstWhere((v) => v.name == result.name);
        showBottomSheet = true;
      }
    });
  }

  Future<void> _onMapTap(GeoPoint point) async {
    setState(() {
      selectedPoint = point;
      showBottomSheet = false;
      selectedVenue = null;
    });

    // Check if tapped on a venue marker
    for (var venue in venues) {
      final distance = _calculateDistance(point, venue.position);
      if (distance < 50) {
        // 50 meters threshold
        setState(() {
          selectedVenue = venue;
          showBottomSheet = true;
        });
        break;
      }
    }
  }

  void _changeMapLayer(MapLayer layer) {
    // Implement layer switching logic
    // Note: OSM plugin may have limited layer support
  }

  void _startVoiceSearch() {
    _showSnackBar(
      'Tìm kiếm bằng giọng nói sẽ được cập nhật trong phiên bản tiếp theo',
    );
  }

  void _getDirections() {
    if (selectedVenue != null) {
      _showSnackBar('Đang mở chỉ đường đến ${selectedVenue!.name}');
      // Implement directions
    }
  }

  void _makeCall() {
    _showSnackBar('Đang gọi đến ${selectedVenue?.name}');
    // Implement phone call
  }

  void _shareLocation() {
    _showSnackBar('Đang chia sẻ vị trí ${selectedVenue?.name}');
    // Implement sharing
  }

  void _toggleFavorite() {
    _showSnackBar('Đã thêm ${selectedVenue?.name} vào danh sách yêu thích');
    // Implement favorite toggle
  }

  double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    // Simple distance calculation in meters (Haversine formula)
    const double earthRadius = 6371000;
    double lat1Rad = point1.latitude * (pi / 180);
    double lat2Rad = point2.latitude * (pi / 180);
    double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    double deltaLon = (point2.longitude - point1.longitude) * (pi / 180);

    double a =
        pow(sin(deltaLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Model classes
enum MapLayer { standard, satellite, terrain, hybrid }

class VenueMarker {
  final String id;
  final String name;
  final String category;
  final GeoPoint position;
  final double rating;
  final String price;
  final String imageUrl;

  VenueMarker({
    required this.id,
    required this.name,
    required this.category,
    required this.position,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });
}

class SearchResult {
  final String name;
  final String address;
  final String type;
  final GeoPoint position;
  final double rating;
  final String price;
  final double distance;

  SearchResult({
    required this.name,
    required this.address,
    required this.type,
    required this.position,
    required this.rating,
    required this.price,
    required this.distance,
  });
}
