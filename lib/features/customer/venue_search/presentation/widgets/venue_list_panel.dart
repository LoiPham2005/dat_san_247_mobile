import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'venue_card.dart';

class VenueListPanel extends StatelessWidget {
  final List<VenueSearchResultModel> venues;
  final NumberFormat priceFmt;
  final ScrollController scrollCtrl;
  final ValueChanged<VenueSearchResultModel> onTap;

  final Widget? header;

  const VenueListPanel({
    super.key,
    required this.venues,
    required this.priceFmt,
    required this.scrollCtrl,
    required this.onTap,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (header != null) header!,
        if (venues.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_outlined, size: 56, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  const Text('Không tìm thấy sân',
                      style: TextStyle(color: Color(0xFF7A8FA6), fontSize: 14)),
                ],
              ),
            ),
          )
        else
          ...venues.map((v) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: VenueCard(
                  venue: v,
                  priceFmt: priceFmt,
                  onTap: () => onTap(v),
                ),
              )),
      ],
    );
  }
}
