import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController controller;
  GeoPoint? selectedPoint;
  String address = "";

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(latitude: 10.762622, longitude: 106.660172),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Yêu cầu quyền vị trí"),
            content: const Text("Bạn cần cấp quyền vị trí để xác định vị trí của bạn."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Đóng"),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text("Cài đặt"),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await _requestLocationPermission();
      final position = await controller.myLocation();
      if (position != null) {
        await controller.goToLocation(position);
        await _onMapTap(position);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể lấy vị trí hiện tại: $e")),
        );
      }
    }
  }

  Future<void> _onMapTap(GeoPoint point) async {
    try {
      // Xóa marker cũ nếu có
      if (selectedPoint != null) {
        await controller.removeMarker(selectedPoint!);
      }

      setState(() {
        selectedPoint = point;
        address = "Vị trí đã chọn: Lat: ${point.latitude.toStringAsFixed(6)}, Lng: ${point.longitude.toStringAsFixed(6)}";
      });

      // Thêm marker mới
      await controller.addMarker(
        point,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.red, size: 48),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi thêm marker: $e")),
        );
      }
    }
  }

  void _clearSelection() async {
    if (selectedPoint != null) {
      try {
        await controller.removeMarker(selectedPoint!);
        setState(() {
          selectedPoint = null;
          address = "";
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi khi xóa marker: $e")),
          );
        }
      }
    }
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
              const Color(0xff62b766).withOpacity(0.12),
              Colors.white,
              const Color(0xff4fa553).withOpacity(0.06),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
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
                        gradient: const LinearGradient(
                          colors: [Color(0xff62b766), Color(0xff4fa553)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff62b766).withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.map, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Chọn vị trí trên bản đồ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2d5533),
                        ),
                      ),
                    ),
                    // Nút lấy vị trí hiện tại
                    IconButton(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xff62b766),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Card chứa bản đồ
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: OSMFlutter(
                        controller: controller,
                        osmOption: OSMOption(
                          userLocationMarker: UserLocationMaker(
                            personMarker: const MarkerIcon(
                              icon: Icon(Icons.location_history_rounded,
                                color: Colors.red,
                                size: 48,
                              ),
                            ),
                            directionArrowMarker: const MarkerIcon(
                              icon: Icon(Icons.double_arrow,
                                size: 48,
                              ),
                            ),
                          ),
                          zoomOption: const ZoomOption(
                            minZoomLevel: 3,
                            maxZoomLevel: 18,
                            initZoom: 14,
                          ),
                          userTrackingOption: const UserTrackingOption(
                            enableTracking: false,
                            unFollowUser: false,
                          ),
                        ),
                        mapIsLoading: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xff62b766),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Đang tải bản đồ...",
                                style: TextStyle(
                                  color: Color(0xff2d5533),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onGeoPointClicked: (geoPoint) async {
                          await _onMapTap(geoPoint);
                        },
                        onMapIsReady: (ready) {
                          if (ready && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Bản đồ đã sẵn sàng! Chạm vào bản đồ để chọn vị trí."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Hiển thị địa chỉ đã chọn
                if (address.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff62b766).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xff62b766)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff2d5533),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Nút xóa selection
                        IconButton(
                          onPressed: _clearSelection,
                          icon: const Icon(Icons.clear),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.all(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Nút xác nhận (nếu cần)
                if (selectedPoint != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý khi người dùng xác nhận vị trí
                          Navigator.pop(context, selectedPoint);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff62b766),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Xác nhận vị trí",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Hướng dẫn sử dụng
                if (selectedPoint == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff62b766).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xff62b766).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xff62b766)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Chạm vào bản đồ để chọn vị trí hoặc nhấn biểu tượng GPS để lấy vị trí hiện tại",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff2d5533),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}