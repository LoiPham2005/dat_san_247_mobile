import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
import 'package:flutter/material.dart';

class SportCategories extends StatefulWidget {
  final List<SportCategory> sportCategory;
  const SportCategories({super.key, required this.sportCategory});

  @override
  State<SportCategories> createState() => _SportCategoriesState();
}

class _SportCategoriesState extends State<SportCategories> {
  final List<SportCategoryItem> categories = [
    SportCategoryItem(
      name: "Bóng đá",
      icon: Icons.sports_soccer,
      color: Colors.green,
      venueCount: 125,
      gradient: [Colors.green.shade400, Colors.green.shade600],
    ),
    SportCategoryItem(
      name: "Cầu lông",
      icon: Icons.sports_tennis,
      color: Colors.blue,
      venueCount: 89,
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
    ),
    SportCategoryItem(
      name: "Bóng rổ",
      icon: Icons.sports_basketball,
      color: Colors.orange,
      venueCount: 67,
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
    ),
    SportCategoryItem(
      name: "Tennis",
      icon: Icons.sports_tennis,
      color: Colors.purple,
      venueCount: 45,
      gradient: [Colors.purple.shade400, Colors.purple.shade600],
    ),
    SportCategoryItem(
      name: "Bóng chuyền",
      icon: Icons.sports_volleyball,
      color: Colors.red,
      venueCount: 38,
      gradient: [Colors.red.shade400, Colors.red.shade600],
    ),
    SportCategoryItem(
      name: "Bơi lội",
      icon: Icons.pool,
      color: Colors.cyan,
      venueCount: 28,
      gradient: [Colors.cyan.shade400, Colors.cyan.shade600],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loại sân thể thao',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // itemCount: categories.length,
              itemCount: widget.sportCategory.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                // final category = widget.sportCategory[index];
                return Container(
                  width: 90,
                  margin: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : 16,
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: category.gradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: category.color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category.icon,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${category.venueCount} sân',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (category.venueCount > 100)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'HOT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SportCategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final int venueCount;
  final List<Color> gradient;

  SportCategoryItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.venueCount,
    required this.gradient,
  });
}
