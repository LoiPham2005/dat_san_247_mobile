// welcome_page.dart
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dat_san_247_mobile/features/intro/data/models/intro_model.dart';
import 'package:dat_san_247_mobile/features/intro/presentation/widgets/intro_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<IntroModel> introData = [
    IntroModel(
      icon: Icons.sports_soccer,
      title: "Tìm Sân Dễ Dàng",
      subtitle: "Khám phá ngay",
      description:
          "Tìm kiếm và khám phá hàng ngàn sân thể thao chất lượng gần bạn với hệ thống tìm kiếm thông minh và bản đồ tương tác.",
      gradient: [Color(0xff62b766), Color(0xff4fa553)],
      backgroundColor: Color(0xfff8fff9),
    ),
    IntroModel(
      icon: Icons.schedule,
      title: "Đặt Sân Nhanh Chóng",
      subtitle: "Chỉ 30 giây",
      description:
          "Đặt sân thể thao yêu thích chỉ với vài chạm. Thanh toán an toàn, xác nhận tức thì, không cần chờ đợi.",
      gradient: [Color(0xff62b766), Color(0xff4fa553)],
      backgroundColor: Color(0xfffef9e7),
    ),
    IntroModel(
      icon: Icons.local_offer,
      title: "Ưu Đãi Đặc Biệt",
      subtitle: "Tiết kiệm 50%",
      description:
          "Nhận voucher giảm giá, tích điểm thưởng và tham gia các chương trình khuyến mãi độc quyền dành cho thành viên.",
      gradient: [Color(0xff62b766), Color(0xff4fa553)],
      backgroundColor: Color(0xfff3f8ff),
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
  }

  void _nextContent() {
    if (currentIndex < introData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    // Navigator logic here
    Get.offAll(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              introData[currentIndex].backgroundColor.withOpacity(0.3),
              Colors.white,
              introData[currentIndex].backgroundColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header với logo và skip button
              _buildHeader(),

              // Main content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    _slideController.reset();
                    _slideController.forward();
                  },
                  itemCount: introData.length,
                  itemBuilder: (context, index) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: IntroContent(data: introData[index]),
                      ),
                    );
                  },
                ),
              ),

              // Bottom section
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff62b766), Color(0xff4fa553)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff62b766).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.sports_soccer, color: Colors.white, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                "SprotHub",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2d5533),
                ),
              ),
            ],
          ),

          // Skip button
          if (currentIndex < introData.length - 1)
            TextButton(
              onPressed: _navigateToLogin,
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: Text(
                "Bỏ qua",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              introData.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: currentIndex == index
                      ? LinearGradient(
                          colors: [Color(0xff62b766), Color(0xff4fa553)],
                        )
                      : null,
                  color: currentIndex == index ? null : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          // Action button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff62b766), Color(0xff4fa553)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff62b766).withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _nextContent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentIndex == introData.length - 1
                        ? "Bắt Đầu"
                        : "Tiếp Tục",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    currentIndex == introData.length - 1
                        ? Icons.rocket_launch
                        : Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Login suggestion
          Text.rich(
            TextSpan(
              text: "Đã có tài khoản? ",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              children: [
                TextSpan(
                  text: "Đăng nhập ngay",
                  style: TextStyle(
                    color: Color(0xff62b766),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
