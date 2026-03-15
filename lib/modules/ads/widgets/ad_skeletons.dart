import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
// SHARED SKELETON HELPERS
// ─────────────────────────────────────────────────────────────────

Widget shimmerBox(double w, double h, {double r = 4}) => Container(
  width: w,
  height: h,
  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(r)),
);

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton(this.size, this.sticky, {super.key});
  final Size size;
  final bool sticky;

  @override
  Widget build(BuildContext context) => Container(
    width: sticky ? double.infinity : size.width,
    height: size.height,
    color: Colors.grey[200],
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[400]),
        ),
        const SizedBox(height: 4),
        Text(
          'ADVERTISEMENT',
          style: TextStyle(fontSize: 8, color: Colors.grey[500], letterSpacing: 1.2),
        ),
      ],
    ),
  );
}

class NativeSkeleton extends StatelessWidget {
  const NativeSkeleton({super.key, required this.isSmall, required this.height});
  final bool isSmall;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: isSmall ? _small() : _medium(),
  );

  Widget _small() => Row(
    children: [
      shimmerBox(60, 60, r: 8),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            shimmerBox(double.infinity, 14),
            const SizedBox(height: 8),
            shimmerBox(120, 10),
          ],
        ),
      ),
      const SizedBox(width: 12),
      shimmerBox(80, 32, r: 16),
    ],
  );

  Widget _medium() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          shimmerBox(40, 40, r: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [shimmerBox(150, 14), const SizedBox(height: 6), shimmerBox(100, 10)],
            ),
          ),
          shimmerBox(20, 20),
        ],
      ),
      const SizedBox(height: 12),
      Expanded(child: shimmerBox(double.infinity, double.infinity, r: 8)),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [shimmerBox(180, 12), const SizedBox(height: 6), shimmerBox(130, 10)],
          ),
          shimmerBox(90, 34, r: 17),
        ],
      ),
    ],
  );
}

class AdListSkeleton extends StatelessWidget {
  const AdListSkeleton({
    super.key,
    required this.height,
    required this.margin,
    required this.radius,
    required this.bg,
  });
  final double height;
  final EdgeInsets margin;
  final double radius;
  final Color bg;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    margin: margin,
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
    child: Row(
      children: [
        Container(
          width: height,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  margin: const EdgeInsets.only(right: 40, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 10,
                  margin: const EdgeInsets.only(right: 80),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 70,
          height: 26,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ],
    ),
  );
}
