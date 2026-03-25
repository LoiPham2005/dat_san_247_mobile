import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';

class DealsAppBar extends StatelessWidget {
  const DealsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading:
          context.canPop() && context.findAncestorWidgetOfExactType<MainShellPage>() == null,
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primaryLightBrand,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          'Ưu đãi & Voucher',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F7A35), Color(0xFF22C55E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                left: 40,
                bottom: -30,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.confirmation_number_outlined, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
