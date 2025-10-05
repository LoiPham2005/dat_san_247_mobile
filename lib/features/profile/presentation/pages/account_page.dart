// import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
// import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
// import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
// import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
// import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/edit_profile_page.dart';
// import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/setting_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:dat_san_247_mobile/core/lang/language_service.dart';
// import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
// import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
// import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
// import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';

// class AccountScreen extends StatelessWidget {
//   AccountScreen({super.key});

//   final AuthController authController = Get.put(AuthController());
//   final ThemeService themeService = Get.find<ThemeService>();
//   final LocalizationService localizationService =
//       Get.find<LocalizationService>();

//   final List<Map<String, dynamic>> items = [
//     {"title": "Tài khoản", "icon": Icons.person},
//     {"title": "Lịch sử đặt sân", "icon": Icons.history},
//     {"title": "Sân đã đặt", "icon": Icons.event_available},
//     {"title": "Yêu thích", "icon": Icons.favorite},
//     {"title": "Địa chỉ của tôi", "icon": Icons.location_on},
//     {"title": "Thanh toán & ví", "icon": Icons.account_balance_wallet},
//     {"title": "Thông báo", "icon": Icons.notifications},
//     {"title": "Đánh giá của tôi", "icon": Icons.rate_review},
//     {"title": "Cài đặt", "icon": Icons.settings},
//     {"title": "Trợ giúp", "icon": Icons.help},
//     {"title": "Về ứng dụng", "icon": Icons.info},
//   ];

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(Language.current.confirmLogout),
//           content: Text(Language.current.confirmLogoutMessage),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(Language.current.cancel),
//             ),
//             TextButton(
//               onPressed: () {
//                 authController
//                     .logout()
//                     .then((_) {
//                       Get.offAll(() => LoginPage());
//                       Get.snackbar('Success', Language.current.logoutSuccess);
//                     })
//                     .catchError((error) {
//                       Get.snackbar(
//                         'Error',
//                         Language.current.logoutFailed,
//                         backgroundColor: Colors.red,
//                         colorText: Colors.white,
//                       );
//                     });
//               },
//               child: Text(
//                 Language.current.logout,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showThemeBottomSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Get.theme.scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: themeService.themes.keys.map((key) {
//             return ListTile(
//               title: Text(
//                 key.toString().split('.').last,
//               ), // hiển thị Light, Dark...
//               trailing: Obx(
//                 () => themeService.currentThemeKey == key
//                     ? const Icon(Icons.check, color: Colors.green)
//                     : const SizedBox(),
//               ),
//               onTap: () {
//                 themeService.changeTheme(key);
//                 Get.back();
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   void _showLanguageBottomSheet() {
//     Get.bottomSheet(
//       Obx(
//         () => Container(
//           decoration: BoxDecoration(
//             color: Get.theme.scaffoldBackgroundColor,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: localizationService.supportedLocales.keys.map((name) {
//               return ListTile(
//                 title: Text(name),
//                 trailing: localizationService.currentLanguageName == name
//                     ? const Icon(Icons.check, color: Colors.green)
//                     : const SizedBox(),
//                 // trailing: Obx(() {
//                 //   final current = Get.find<LanguageService>().currentLocale;
//                 //   return Text(current.theme);
//                 // }),
//                 onTap: () async {
//                   await localizationService.changeLocale(name);
//                   Get.back();
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xff62b766).withOpacity(0.1),
//               Colors.white,
//               Color(0xff4fa553).withOpacity(0.05),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   Row(
//                     children: [
//                       Container(
//                         width: 32,
//                         height: 32,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Color(0xff62b766), Color(0xff4fa553)],
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         "Thông tin cá nhân",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff2d5533),
//                         ),
//                       ),
//                       Spacer(),
//                       IconButton(
//                         icon: Icon(Icons.edit, color: Color(0xff62b766)),
//                         onPressed: () {
//                           Get.to(() => const EditProfilePage());
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 24),

//                   // Profile Card
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 12,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         CustomImage(
//                           height: 60,
//                           width: 60,
//                           fit: BoxFit.cover,
//                           radius: 30,
//                           imageUrl:
//                               "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'phamducloi',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff2d5533),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'phamducloi919@gmail.com',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24),

//                   // Menu
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     separatorBuilder: (context, index) => SizedBox(height: 10),
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final item = items[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                         child: ListTile(
//                           leading: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xff62b766), Color(0xff4fa553)],
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             width: 36,
//                             height: 36,
//                             child: Icon(
//                               item["icon"] as IconData,
//                               color: Colors.white,
//                             ),
//                           ),
//                           title: Text(
//                             item["title"] as String,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff2d5533),
//                             ),
//                           ),
//                           trailing: Icon(
//                             Icons.arrow_forward_ios,
//                             size: 18,
//                             color: Colors.grey[400],
//                           ),
//                           onTap: () {
//                             if (item["title"] == "Cài đặt") {
//                               Get.to(() => SettingPage());
//                             }
//                             // Các xử lý khác...
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 24),

//                   // Logout button
//                   Center(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 12,
//                         ),
//                       ),
//                       icon: Icon(Icons.logout),
//                       label: Text(
//                         "Đăng xuất",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () {
//                         _confirmLogout(context);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
import 'package:dat_san_247_mobile/core/localization/localization_service.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/image/custom_image.dart';
import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/edit_profile_page.dart';
import 'package:dat_san_247_mobile/features/profile/presentation/pages/page/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/theme/theme_service.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final ThemeService themeService = Get.find<ThemeService>();
  final LocalizationService localizationService =
      Get.find<LocalizationService>();

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Tài khoản",
      "icon": Icons.person_rounded,
      "color": Color(0xFF2196F3),
      "subtitle": "Quản lý thông tin cá nhân",
    },
    {
      "title": "Lịch sử đặt sân",
      "icon": Icons.history_rounded,
      "color": Color(0xFF4CAF50),
      "subtitle": "Xem các lần đặt sân trước",
    },
    {
      "title": "Sân đã đặt",
      "icon": Icons.event_available_rounded,
      "color": Color(0xFFFF9800),
      "subtitle": "Sân sắp tới",
    },
    {
      "title": "Yêu thích",
      "icon": Icons.favorite_rounded,
      "color": Color(0xFFE91E63),
      "subtitle": "Các sân yêu thích",
    },
    {
      "title": "Địa chỉ của tôi",
      "icon": Icons.location_on_rounded,
      "color": Color(0xFF9C27B0),
      "subtitle": "Quản lý địa chỉ",
    },
    {
      "title": "Thanh toán & ví",
      "icon": Icons.account_balance_wallet_rounded,
      "color": Color(0xFF00BCD4),
      "subtitle": "Phương thức thanh toán",
    },
    {
      "title": "Thông báo",
      "icon": Icons.notifications_rounded,
      "color": Color(0xFFFF5722),
      "subtitle": "Cài đặt thông báo",
    },
    {
      "title": "Đánh giá của tôi",
      "icon": Icons.rate_review_rounded,
      "color": Color(0xFFFFD700),
      "subtitle": "Đánh giá và nhận xét",
    },
    {
      "title": "Cài đặt",
      "icon": Icons.settings_rounded,
      "color": Color(0xFF607D8B),
      "subtitle": "Tùy chỉnh ứng dụng",
    },
    {
      "title": "Trợ giúp",
      "icon": Icons.help_outline_rounded,
      "color": Color(0xFF795548),
      "subtitle": "Hỗ trợ khách hàng",
    },
    {
      "title": "Về ứng dụng",
      "icon": Icons.info_outline_rounded,
      "color": Color(0xFF3F51B5),
      "subtitle": "Thông tin ứng dụng",
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF5722).withOpacity(0.1),
                        Color(0xFFF44336).withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFF44336),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Xác nhận đăng xuất',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2d5533),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  Language.current.confirmLogoutMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          Language.current.cancel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF44336), Color(0xFFE53935)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFF44336).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            authController
                                .logout()
                                .then((_) {
                                  Get.offAll(() => LoginPage());
                                  Get.snackbar(
                                    'Success',
                                    Language.current.logoutSuccess,
                                  );
                                })
                                .catchError((error) {
                                  Get.snackbar(
                                    'Error',
                                    Language.current.logoutFailed,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            Language.current.logout,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeService.themes.keys.map((key) {
            return ListTile(
              title: Text(key.toString().split('.').last),
              trailing: Obx(
                () => themeService.currentThemeKey == key
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox(),
              ),
              onTap: () {
                themeService.changeTheme(key);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() {
    Get.bottomSheet(
      Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: localizationService.supportedLocales.keys.map((name) {
              return ListTile(
                title: Text(name),
                trailing: localizationService.currentLanguageName == name
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox(),
                onTap: () async {
                  await localizationService.changeLocale(name);
                  Get.back();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF62b766).withOpacity(0.8),
              Color(0xFF4fa553).withOpacity(0.9),
              Color(0xFF3d8b40),
              Color(0xFF2d5533),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    expandedHeight: 0,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    leading: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    actions: [
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            Get.to(() => const EditProfilePage());
                          },
                        ),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile Header with Floating Effect
                          AnimatedBuilder(
                            animation: _floatingAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatingAnimation.value),
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: _buildProfileHeader(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          // Quick Stats Section
                          _buildQuickStats(),

                          const SizedBox(height: 24),

                          // Menu Items
                          _buildMenuSection(),

                          const SizedBox(height: 32),

                          // Logout Button with Pulse Effect
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: _buildLogoutButton(),
                              );
                            },
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with Glow
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Color(0xFF4fa553).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: CustomImage(
                    height: 92,
                    width: 92,
                    fit: BoxFit.cover,
                    radius: 46,
                    imageUrl:
                        "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sports_soccer_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            'phamducloi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Email with Glass Effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.email_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'phamducloi919@gmail.com',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              '24',
              'Sân đã đặt',
              Icons.sports_soccer_rounded,
              Color(0xFF4CAF50),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _buildStatItem(
              '156h',
              'Thời gian chơi',
              Icons.access_time_rounded,
              Color(0xFF2196F3),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _buildStatItem(
              '8',
              'Sân yêu thích',
              Icons.favorite_rounded,
              Color(0xFFE91E63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.8),
                      Colors.deepOrange.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(opacity: value, child: _buildMenuItem(item)),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (item["title"] == "Cài đặt") {
              Get.to(() => SettingPage());
            }
            // Handle other menu items
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (item["color"] as Color).withOpacity(0.8),
                        (item["color"] as Color).withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (item["color"] as Color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["subtitle"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF5722), Color(0xFFF44336)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF44336).withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _confirmLogout(context),
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Đăng xuất",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
