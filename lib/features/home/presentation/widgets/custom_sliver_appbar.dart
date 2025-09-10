import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onSearchTap;

  const CustomSliverAppBar({
    super.key,
    required this.isCollapsed,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      collapsedHeight: 70,
      // backgroundColor: Colors.amber,
      elevation: 4,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tiêu đề AppBar
                AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize: isCollapsed ? 18 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Text(Language.current.nameApp),
                ),
                const SizedBox(height: 8),

                // Ô tìm kiếm hoặc icon tìm kiếm
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      SizeTransition(sizeFactor: animation, child: child),
                  child: isCollapsed
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            key: const ValueKey("icon"),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: onSearchTap,
                          ),
                        )
                      : Container(
                          key: const ValueKey("search"),
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Tìm kiếm sản phẩm...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey),
                            ),
                            onSubmitted: (value) {
                              debugPrint("Tìm kiếm: $value");
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
