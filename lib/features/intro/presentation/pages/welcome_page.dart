import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/share_pref.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/widgets/button_intro.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/widgets/content_intro.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/widgets/header_intro.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final AuthController controller = Get.find<AuthController>();
  final List<Map<String, String>> args = [
    {
      'image': ImagePath.intro1,
      'title': "Đặt sân nhanh chóng & tiện lợi",
      'content':
          "Chỉ với vài thao tác, bạn có thể dễ dàng đặt sân \ntại các địa điểm thể thao yêu thích. Tiết kiệm \nthời gian, đặt sân mọi lúc, mọi nơi!",
    },
    {
      'image': ImagePath.intro2,
      'title': "Cập nhật lịch đặt sân theo thời gian thực",
      'content':
          "Theo dõi tình trạng sân trống và lịch đặt sân \ntrực tiếp ngay trên ứng dụng. Không lo trùng \nlịch, không bỏ lỡ trận đấu nào!",
    },
    {
      'image': ImagePath.intro2,
      'title': "Nhận ưu đãi & khuyến mãi hấp dẫn",
      'content':
          "Tận hưởng nhiều chương trình giảm giá đặc \nbệt dành riêng cho thành viên. Đặt sân dễ \ndàng, giá cực ưu đãi!",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await controller.loadUserFromLocal();
    if (controller.userList.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        PageTransition.slideTransition(BottomMenuCustom()),
      );
    }
  }

  void _nextContent() {
    setState(() {
      if (currentIndex < args.length - 1) {
        currentIndex++;
        _pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition.slideTransition(LoginPage()),
        );

        SharedPrefs.setBool(DbKeysLocal.isFirstRun, true);
      }
    });
  }

  void _skipContent() async {
    // final isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin) ?? false;
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition.slideTransition(LoginPage()),
    // );

    SharedPrefs.setBool(DbKeysLocal.isFirstRun, true);

    Get.to(
      () => LoginPage(),
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderIntro(),
          80.height,
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: args.length,
              itemBuilder: (context, index) {
                final item = args[index];
                return ContentIntro(
                  image: item['image']!,
                  title: item['title']!,
                  content: item['content']!,
                );
              },
            ),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...args.map((e) {
                int index = args.indexOf(e);
                bool isSelected = index == currentIndex;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: isSelected ? 16 : 4,
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorApp.primaryColor : Colors.grey,
                  ),
                );
              }),
            ],
          ),
          20.height,
          Text(
            "ĐĂNG NHẬP HOẶC ĐĂNG KÝ",
            style: TextStyle(
              fontSize: 16, // 16px từ Figma
              fontWeight: FontWeight.w300,
              color: ColorApp.primaryColor,
            ),
          ),
          40.height,
          ButtonIntro(onContinue: _nextContent, onSkip: _skipContent),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
