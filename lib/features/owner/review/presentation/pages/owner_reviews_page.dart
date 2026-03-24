import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/review/data/models/review_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-12: Quản Lý Đánh Giá (Owner View)
// DB: reviews (venue_id IN owned, is_visible=true), users (reviewer)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerReviewsPage extends StatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerReviewsPage({super.key, required this.venueId, required this.venueName});
  @override
  State<OwnerReviewsPage> createState() => _OwnerReviewsPageState();
}

class _OwnerReviewsPageState extends State<OwnerReviewsPage> {
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

  int? _ratingFilter;
  List<OwnerReviewModel> _reviews = _buildMock();

  static List<OwnerReviewModel> _buildMock() {
    final now = DateTime.now();
    return [
      OwnerReviewModel(id:'r1', bookingId:'b1', venueId:'v1', userId:'u1', reviewerName:'Nguyễn Văn An', rating:5, ratingCleanliness:5, ratingFacilities:5, ratingStaff:4, comment:'Sân rất tốt, nhân viên nhiệt tình. Sẽ quay lại!', createdAt:now.subtract(const Duration(hours:2))),
      OwnerReviewModel(id:'r2', bookingId:'b2', venueId:'v1', userId:'u2', reviewerName:'Lê Thị Bình', rating:4, ratingCleanliness:4, ratingFacilities:4, ratingStaff:5, comment:'Giá cả hợp lý, sân cỏ nhân tạo chất lượng tốt.', response:'Cảm ơn bạn đã tin tưởng sử dụng dịch vụ! Hẹn gặp lại.', respondedAt:now.subtract(const Duration(hours:1)), createdAt:now.subtract(const Duration(days:1))),
      OwnerReviewModel(id:'r3', bookingId:'b3', venueId:'v1', userId:'u3', reviewerName:'Phạm Quốc Cường', rating:2, ratingCleanliness:2, ratingFacilities:3, ratingStaff:2, comment:'Nhà vệ sinh không sạch, ánh đèn sân yếu vào ban đêm.', createdAt:now.subtract(const Duration(days:3))),
      OwnerReviewModel(id:'r4', bookingId:'b4', venueId:'v1', userId:'u4', reviewerName:'Hoàng Minh Đức', rating:5, ratingCleanliness:5, ratingFacilities:5, ratingStaff:5, comment:'Tuyệt vời! Sân đẹp, không gian thoáng đãng.', createdAt:now.subtract(const Duration(days:5))),
      OwnerReviewModel(id:'r5', bookingId:'b5', venueId:'v1', userId:'u5', reviewerName:'Trần Văn Em', rating:3, ratingCleanliness:3, ratingFacilities:3, ratingStaff:4, comment:'Tạm được, giá hơi cao so với chất lượng.', createdAt:now.subtract(const Duration(days:7))),
    ];
  }

  List<OwnerReviewModel> get _filtered =>
    _ratingFilter == null ? _reviews : _reviews.where((r) => r.rating == _ratingFilter).toList();

  double get _avgRating => _reviews.isEmpty ? 0 : _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
  double get _avgClean => _avg(_reviews.map((r) => r.ratingCleanliness).whereType<int>().toList());
  double get _avgFacil => _avg(_reviews.map((r) => r.ratingFacilities).whereType<int>().toList());
  double get _avgStaff => _avg(_reviews.map((r) => r.ratingStaff).whereType<int>().toList());
  double _avg(List<int> vals) => vals.isEmpty ? 0 : vals.reduce((a, b) => a + b) / vals.length;

  Map<int, int> get _distribution {
    final map = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _reviews) map[r.rating] = (map[r.rating] ?? 0) + 1;
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        // ── AppBar ──
        SliverAppBar(
          pinned: true, expandedHeight: 130, backgroundColor: _brand,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.venueName, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                const Text('Đánh Giá Của Khách', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(_avgRating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
                  const SizedBox(width: 4),
                  Text('(${_reviews.length} đánh giá)', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const Spacer(),
                  Text('${_reviews.where((r) => r.hasResponse).length}/${_reviews.length} đã phản hồi', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
              ]))),
            ),
            title: const Text('Đánh Giá', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),

        // ── Rating summary card ──
        SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tổng Quan Đánh Giá', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Big score
              Column(children: [
                Text(_avgRating.toStringAsFixed(1), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF0891B2))),
                _StarRow(_avgRating),
                Text('${_reviews.length} đánh giá', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
              const SizedBox(width: 20),
              // Distribution bars
              Expanded(child: Column(children: [5, 4, 3, 2, 1].map((star) {
                final count = _distribution[star] ?? 0;
                final ratio = _reviews.isEmpty ? 0.0 : count / _reviews.length;
                return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
                  Text('$star', style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  const Icon(Icons.star_rounded, size: 10, color: Colors.amber),
                  const SizedBox(width: 6),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: ratio, backgroundColor: AppColors.borderLight, color: _starColor(star), minHeight: 8))),
                  const SizedBox(width: 6),
                  SizedBox(width: 16, child: Text('$count', style: const TextStyle(fontSize: 10, color: AppColors.textHint), textAlign: TextAlign.end)),
                ]));
              }).toList())),
            ]),
            const Divider(height: 16, color: AppColors.borderLight),
            // Sub-ratings
            Row(children: [
              _SubRating('Sạch sẽ', _avgClean),
              _SubRating('Cơ sở', _avgFacil),
              _SubRating('Nhân viên', _avgStaff),
            ]),
          ]),
        )),

        // ── Rating filter ──
        SliverToBoxAdapter(child: Container(
          color: Colors.transparent, padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            _FChip('Tất cả', _ratingFilter == null, () => setState(() => _ratingFilter = null)),
            _FChip('Chưa phản hồi (${_reviews.where((r) => !r.hasResponse).length})', false, () => setState(() => _ratingFilter = null)),
            ...[5, 4, 3, 2, 1].map((star) => _FChip('$star ⭐', _ratingFilter == star, () => setState(() => _ratingFilter = _ratingFilter == star ? null : star))),
          ])),
        )),

        // ── Review list ──
        _filtered.isEmpty
            ? const SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.rate_review_outlined, size: 48, color: AppColors.textHint), SizedBox(height: 8), Text('Không có đánh giá nào', style: TextStyle(color: AppColors.textHint))])))
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                sliver: SliverList(delegate: SliverChildBuilderDelegate(
                  (_, i) => _ReviewCard(
                    review: _filtered[i],
                    onReply: () => _showReplySheet(context, _filtered[i]),
                  ),
                  childCount: _filtered.length,
                )),
              ),
      ]),
    );
  }

  void _showReplySheet(BuildContext context, OwnerReviewModel review) {
    final replyCtrl = TextEditingController(text: review.response ?? '');
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 14),
        Row(children: [const Icon(Icons.reply_rounded, color: Color(0xFF0891B2)), const SizedBox(width: 8), Text('Phản hồi: ${review.reviewerName}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.borderLight.withOpacity(0.5), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _StarRow(review.rating.toDouble()),
          const SizedBox(height: 4),
          Text(review.comment ?? '(Không có nội dung)', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
        ])),
        const SizedBox(height: 12),
        TextField(controller: replyCtrl, maxLines: 4, keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: 'Viết phản hồi của bạn...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.all(12))),
        const SizedBox(height: 8),
        const Text('Phản hồi sẽ hiển thị công khai cho khách xem.', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () {
            if (replyCtrl.text.isEmpty) return;
            Navigator.pop(ctx);
            setState(() {
              final idx = _reviews.indexWhere((r) => r.id == review.id);
              if (idx >= 0) _reviews[idx] = OwnerReviewModel(id:review.id, bookingId:review.bookingId, venueId:review.venueId, courtId:review.courtId, userId:review.userId, reviewerName:review.reviewerName, rating:review.rating, ratingCleanliness:review.ratingCleanliness, ratingFacilities:review.ratingFacilities, ratingStaff:review.ratingStaff, comment:review.comment, response:replyCtrl.text, respondedAt:DateTime.now(), createdAt:review.createdAt);
            });
            HapticFeedback.mediumImpact();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã gửi phản hồi'), backgroundColor: AppColors.success));
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0891B2), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Gửi Phản Hồi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )),
      ]))),
    );
  }

  Color _starColor(int star) => switch (star) { 5 => AppColors.success, 4 => const Color(0xFF22C55E), 3 => AppColors.warning, 2 => AppColors.error, _ => AppColors.error };
}

// ── Review Card ───────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final OwnerReviewModel review; final VoidCallback onReply;
  const _ReviewCard({required this.review, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: review.hasResponse ? AppColors.success.withOpacity(0.2) : AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.1), shape: BoxShape.circle),
              child: Center(child: Text(review.reviewerName[0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0891B2))))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(review.reviewerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(DateFormat('dd/MM/yyyy').format(review.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
            ])),
            _StarRow(review.rating.toDouble()),
          ]),
          if (review.comment != null) ...[
            const SizedBox(height: 10),
            Text(review.comment!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
          if (review.ratingCleanliness != null || review.ratingFacilities != null || review.ratingStaff != null) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: [
              if (review.ratingCleanliness != null) _MiniStar('Sạch sẽ', review.ratingCleanliness!),
              if (review.ratingFacilities != null) _MiniStar('Cơ sở', review.ratingFacilities!),
              if (review.ratingStaff != null) _MiniStar('Nhân viên', review.ratingStaff!),
            ]),
          ],
        ])),

        // Owner response
        if (review.hasResponse) ...[
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.success.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.store_rounded, size: 12, color: AppColors.success),
                const SizedBox(width: 4),
                const Text('Phản hồi từ chủ sân', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                const Spacer(),
                if (review.respondedAt != null) Text(DateFormat('dd/MM').format(review.respondedAt!), style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
              ]),
              const SizedBox(height: 6),
              Text(review.response!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
        ],

        const Divider(height: 1, color: AppColors.borderLight),
        Padding(padding: const EdgeInsets.fromLTRB(10, 6, 10, 8), child: GestureDetector(
          onTap: onReply,
          child: Container(padding: const EdgeInsets.symmetric(vertical: 7), decoration: BoxDecoration(color: const Color(0xFF0891B2).withOpacity(0.06), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.reply_rounded, size: 14, color: Color(0xFF0891B2)),
            const SizedBox(width: 6),
            Text(review.hasResponse ? 'Sửa phản hồi' : 'Phản hồi đánh giá', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0891B2))),
          ])),
        )),
      ]),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating; const _StarRow(this.rating);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) => Icon(i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber, size: 13)));
}

class _SubRating extends StatelessWidget {
  final String label; final double value; const _SubRating(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0891B2))),
    _StarRow(value),
    Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
  ]));
}

class _MiniStar extends StatelessWidget {
  final String label; final int value; const _MiniStar(this.label, this.value);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.star_rounded, color: Colors.amber, size: 10), const SizedBox(width: 2), Text('$value $label', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary))]));
}

class _FChip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _FChip(this.label, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () { HapticFeedback.selectionClick(); onTap(); }, child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: selected ? const Color(0xFF0891B2) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: selected ? const Color(0xFF0891B2) : AppColors.borderLight)), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary))));
}
