import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:dat_san_247_mobile/features/intro/widgets/button_intro.dart';
import 'package:dat_san_247_mobile/features/intro/widgets/content_intro.dart';
import 'package:dat_san_247_mobile/features/intro/widgets/header_intro.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final AuthController controller = Get.find<AuthController>();
  final List<Map<String, String>> args = [
    {
      'image': ImagePath.intro1,
      'title': "Tận hưởng ưu đãi với EZDEAL",
      'content':
          "Giá ưu đãi dành riêng cho thành viên của \napp. Sản phẩm và kích thước độc quyền chỉ \ncó trên cửa hàng online"
    },
    {
      'image': ImagePath.intro2,
      'title': "Được thông báo về \ncác ưu đãi đặc biệt",
      'content':
          "Nhận thông báo về sản phẩm mới, khuyến \nmãi, và chương trình giảm giá có hạn"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    // final prefs = await Get.find<SharedPreferences>();
    // if (prefs.getBool(DbKeysLocal.isLogin) ?? false) {
    //   print("Đã đăng nhập");
    //   Navigator.pushReplacement(
    //     context,
    //     PageTransition.slideTransition(BottomMenuCustom()),
    //   );
    // }

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
            context, PageTransition.slideTransition(LoginPage()));
      }
    });
  }

  // void _skipContent() async {
  //   setState(() async {
  //     // currentIndex = args.length - 1;
  //     // _pageController.animateToPage(
  //     //   currentIndex,
  //     //   duration: Duration(milliseconds: 300),
  //     //   curve: Curves.easeInOut,
  //     // );

  //     final isLogin = await SharedPrefs.readBool(DbKeysLocal.isLogin) ?? false;

  //     if (isLogin) {
  //       Navigator.pushReplacement(
  //           context, PageTransition.slideTransition(BottomMenuCustom()));
  //     } else {
  //       Navigator.pushReplacement(
  //           context, PageTransition.slideTransition(LoginScreen2()));
  //     }
  //   });
  // }

  void _skipContent() async {
    final isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin) ?? false;

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        PageTransition.slideTransition(BottomMenuCustom()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition.slideTransition(LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderIntro(),
          SizedBox(
            height: 81,
          ),
          SizedBox(
            height: 300,
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
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...args.map(
                (e) {
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
                },
              ),
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
          SizedBox(
            height: 40, // 40px từ Figma
          ),
          ButtonIntro(
            onContinue: _nextContent,
            onSkip: _skipContent,
          )
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
