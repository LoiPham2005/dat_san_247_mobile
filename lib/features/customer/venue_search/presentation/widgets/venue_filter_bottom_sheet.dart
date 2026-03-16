import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_filter_params.dart';

class VenueFilterBottomSheet extends StatefulWidget {
  final VenueFilterParams initialParams;
  final Function(VenueFilterParams) onApply;

  const VenueFilterBottomSheet({
    super.key,
    required this.initialParams,
    required this.onApply,
  });

  @override
  State<VenueFilterBottomSheet> createState() => _VenueFilterBottomSheetState();
}

class _VenueFilterBottomSheetState extends State<VenueFilterBottomSheet> {
  late VenueFilterParams _currentParams;

  // Mock data for UI
  final List<String> _districts = ['Quận 10', 'Quận 1', 'Quận 3', 'Bình Thạnh', 'Tân Bình', 'Thủ Đức'];
  final List<String> _sportTypes = ['FOOTBALL', 'BADMINTON', 'TENNIS', 'BASKETBALL', 'SWIMMING'];
  final List<String> _amenities = ['WIFI', 'Bãi xe Ô tô', 'Căng tin', 'Tủ đồ', 'Trọng tài'];

  RangeValues _priceRange = const RangeValues(0, 1000); // in thousands
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _currentParams = widget.initialParams;
    _priceRange = RangeValues(
      _currentParams.minPrice ?? 0,
       _currentParams.maxPrice ?? 1000,
    );
    _selectedDate = _currentParams.availableDate;
    if (_currentParams.availableStartTime != null) {
      final parts = _currentParams.availableStartTime!.split(':');
      if (parts.length >= 2) {
        _startTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
  }

  void _onReset() {
    setState(() {
      _currentParams = const VenueFilterParams();
      _priceRange = const RangeValues(0, 1000);
      _selectedDate = null;
      _startTime = null;
      _endTime = null;
    });
  }

  void _onApply() {
    final updatedParams = _currentParams.copyWith(
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice: _priceRange.end < 1000 ? _priceRange.end : null,
      availableDate: _selectedDate,
      availableStartTime: _startTime != null ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}' : null,
      availableEndTime: _endTime != null ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}' : null,
    );
    widget.onApply(updatedParams);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 16),
                  _buildSectionTitle('Môn thể thao'),
                  _buildSportChips(),
                  const Divider(height: 32),
                  
                  _buildSectionTitle('Khu vực (Theo Quận)'),
                  _buildDistrictChips(),
                  const Divider(height: 32),
                  
                  _buildSectionTitle('Khoảng giá (Nghìn VND / Giờ)'),
                  _buildPriceSlider(),
                  const Divider(height: 32),

                  _buildSectionTitle('Tiện ích đi kèm'),
                  _buildAmenitiesChips(),
                  const Divider(height: 32),

                  _buildSectionTitle('Thời gian còn trống'),
                  _buildTimeSelector(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Bộ lọc',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSportChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sportTypes.map((sport) {
        final isSelected = _currentParams.sportType == sport;
        return FilterChip(
          label: Text(sport),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _currentParams = _currentParams.copyWith(sportType: selected ? sport : null);
            });
          },
          selectedColor: AppColors.primaryLightBrand.withOpacity(0.2),
          checkmarkColor: AppColors.primaryLightBrand,
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistrictChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _districts.map((district) {
        final isSelected = _currentParams.district == district;
        return FilterChip(
          label: Text(district),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _currentParams = _currentParams.copyWith(district: selected ? district : null);
            });
          },
          selectedColor: AppColors.primaryLightBrand.withOpacity(0.2),
          checkmarkColor: AppColors.primaryLightBrand,
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmenitiesChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _amenities.map((amenity) {
        final isSelected = _currentParams.amenities.contains(amenity);
        return FilterChip(
          label: Text(amenity),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final newAmenities = List<String>.from(_currentParams.amenities);
              if (selected) {
                newAmenities.add(amenity);
              } else {
                newAmenities.remove(amenity);
              }
              _currentParams = _currentParams.copyWith(amenities: newAmenities);
            });
          },
          selectedColor: AppColors.primaryLightBrand.withOpacity(0.2),
          checkmarkColor: AppColors.primaryLightBrand,
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: isSelected ? AppColors.primaryLightBrand : AppColors.borderLight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_priceRange.start.toInt()}K', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${_priceRange.end.toInt()}K+', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: AppColors.primaryLightBrand,
          inactiveColor: AppColors.borderLight,
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ngày thi đấu', style: TextStyle(fontSize: 14)),
          trailing: Text(
            _selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : 'Chọn ngày',
            style: TextStyle(
              color: _selectedDate != null ? AppColors.textPrimary : AppColors.textHint,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Thời gian bắt đầu (Dự kiến)', style: TextStyle(fontSize: 14)),
          trailing: Text(
            _startTime != null ? _startTime!.format(context) : 'Chọn giờ',
            style: TextStyle(
              color: _startTime != null ? AppColors.textPrimary : AppColors.textHint,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
             final picked = await showTimePicker(
              context: context,
              initialTime: _startTime ?? TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() => _startTime = picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: _onReset,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.borderLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Thiết lập lại', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _onApply,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primaryLightBrand,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Áp dụng', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
