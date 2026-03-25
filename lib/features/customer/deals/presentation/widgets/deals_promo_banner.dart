import 'package:flutter/material.dart';

class DealsPromoBanner extends StatelessWidget {
  const DealsPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(top: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (context, index) {
            final colors = [
              [const Color(0xFFE11D48), const Color(0xFFFB7185)],
              [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
              [const Color(0xFF2563EB), const Color(0xFF60A5FA)],
            ];
            return Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: colors[index % colors.length],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors[index % colors.length][0].withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      size: 100,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Hot Deal',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Giảm giá tới 50%',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Áp dụng cho các sân mới đăng ký',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
