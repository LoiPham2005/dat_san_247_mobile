import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

// ──────────────────────────────────────────────────────────────────────────
// C-12: Viết Đánh Giá
// ──────────────────────────────────────────────────────────────────────────
class WriteReviewPage extends StatefulWidget {
  final String bookingId;
  final String venueName;

  const WriteReviewPage({
    super.key,
    required this.bookingId,
    required this.venueName,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _ratingOverall = 0;
  int _ratingCleanliness = 0;
  int _ratingFacilities = 0;
  int _ratingStaff = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  // Mock image selection
  final List<String> _selectedImages = [];

  bool get _canSubmit => _ratingOverall > 0;

  Future<void> _submit() async {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⭐ Vui lòng đánh giá tổng (số sao)'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Cảm ơn bạn đã đánh giá!'), backgroundColor: AppColors.primaryLightBrand),
    );
    context.pop();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Viết đánh giá', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Venue Header ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Row(
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBrand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports_soccer_rounded, color: AppColors.primaryLightBrand, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.venueName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Text('Đánh giá sẽ giúp các người dùng khác chọn sân tốt hơn', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Overall Rating ── (big stars)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDeco(),
              child: Column(
                children: [
                  const Text('Đánh giá tổng *', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(_ratingOverall == 0 ? 'Chưa đánh giá' : _labelFromRating(_ratingOverall),
                      style: TextStyle(fontSize: 13, color: _ratingOverall > 0 ? AppColors.warning : AppColors.textHint)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _ratingOverall = star),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            star <= _ratingOverall ? Icons.star_rounded : Icons.star_border_rounded,
                            color: star <= _ratingOverall ? AppColors.warning : AppColors.greyLight,
                            size: 44,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Detailed Ratings ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Đánh giá chi tiết', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '🧹 Vệ sinh sân',
                    rating: _ratingCleanliness,
                    onChanged: (v) => setState(() => _ratingCleanliness = v),
                  ),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '🏟️ Cơ sở vật chất',
                    rating: _ratingFacilities,
                    onChanged: (v) => setState(() => _ratingFacilities = v),
                  ),
                  const SizedBox(height: 12),
                  _DetailRatingRow(
                    label: '👷 Nhân viên',
                    rating: _ratingStaff,
                    onChanged: (v) => setState(() => _ratingStaff = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Comment ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nhận xét của bạn', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Chia sẻ trải nghiệm của bạn để giúp người khác...', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    maxLength: 500,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Sân sạch sẽ, nhân viên nhiệt tình, mặt cỏ tốt...',
                      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.mutedLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Photo Upload ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDeco(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thêm ảnh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Tối đa 5 ảnh (JPG, PNG)', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ..._selectedImages.map((path) => _ImagePreview(path: path, onRemove: () => setState(() => _selectedImages.remove(path)))),
                      if (_selectedImages.length < 5)
                        GestureDetector(
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📷 Tính năng upload ảnh sẽ tích hợp sau'))),
                          child: Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.mutedLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, color: AppColors.primaryLightBrand, size: 28),
                                Text('Thêm ảnh', style: TextStyle(fontSize: 9, color: AppColors.primaryLightBrand)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ratingOverall > 0) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (i) => Icon(i < _ratingOverall ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.warning, size: 18)),
                const SizedBox(width: 6),
                Text(_labelFromRating(_ratingOverall), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
              ],
            ),
            if (_ratingOverall > 0) const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isSubmitting || !_canSubmit ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightBrand,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 52),
                elevation: 0,
                disabledBackgroundColor: AppColors.greyLight,
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white))
                  : const Text('Gửi đánh giá', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFromRating(int r) {
    switch (r) {
      case 1: return 'Rất tệ 😞';
      case 2: return 'Tệ 😐';
      case 3: return 'Bình thường 🙂';
      case 4: return 'Tốt 😊';
      case 5: return 'Tuyệt vời! 🤩';
      default: return '';
    }
  }

  BoxDecoration _cardDeco() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
  );
}

// ── Sub-widgets ────────────────────────────────────────────────────────────
class _DetailRatingRow extends StatelessWidget {
  final String label;
  final int rating;
  final ValueChanged<int> onChanged;
  const _DetailRatingRow({required this.label, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
        const Spacer(),
        ...List.generate(5, (i) => GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Icon(
            i < rating ? Icons.star_rounded : Icons.star_border_rounded,
            color: i < rating ? AppColors.warning : AppColors.greyLight,
            size: 26,
          ),
        )),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;
  const _ImagePreview({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(color: AppColors.mutedLight, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.image_rounded, color: AppColors.textHint, size: 36),
        ),
        Positioned(
          top: 0, right: 0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20, height: 20,
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded, color: AppColors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}
