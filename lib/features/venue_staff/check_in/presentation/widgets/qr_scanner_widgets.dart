import 'package:flutter/material.dart';

class QrFrame extends StatelessWidget {
  final Animation<double> scanAnim;
  final Color brand;
  final bool isLoading;
  const QrFrame({super.key, required this.scanAnim, required this.brand, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    const size = 260.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Corner decorations
          Positioned(top: 0, left: 0, child: _Corner(color: brand, rotation: 0)),
          Positioned(top: 0, right: 0, child: _Corner(color: brand, rotation: 90)),
          Positioned(bottom: 0, right: 0, child: _Corner(color: brand, rotation: 180)),
          Positioned(bottom: 0, left: 0, child: _Corner(color: brand, rotation: 270)),
          // Dark overlay inside frame
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Scan line
          if (!isLoading)
            AnimatedBuilder(
              animation: scanAnim,
              builder: (_, __) => Positioned(
                top: 16 + (size - 32) * scanAnim.value,
                left: 16,
                right: 16,
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.transparent, brand, Colors.transparent]),
                    boxShadow: [BoxShadow(color: brand.withOpacity(0.6), blurRadius: 6)],
                  ),
                ),
              ),
            )
          else
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Color color;
  final double rotation;
  const _Corner({required this.color, required this.rotation});

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: rotation * 3.14159 / 180,
        child: SizedBox(
          width: 28,
          height: 28,
          child: CustomPaint(painter: _CornerPainter(color: color)),
        ),
      );
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.5;
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
