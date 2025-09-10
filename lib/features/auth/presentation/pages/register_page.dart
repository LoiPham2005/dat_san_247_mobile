// register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool agreeToTerms = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _slideController.forward();
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
              Color(0xff4fa553).withOpacity(0.1),
              Colors.white,
              Color(0xff62b766).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  // Header
                  _buildHeader(),

                  SizedBox(height: 30),

                  // Welcome section
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildWelcomeSection(),
                  ),

                  SizedBox(height: 30),

                  // Form section
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildFormSection(),
                  ),

                  SizedBox(height: 20),

                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xff2d5533),
              size: 20,
            ),
          ),
        ),
        Spacer(),
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff62b766), Color(0xff4fa553)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.sports_soccer, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
            Text(
              "SprotHub",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff2d5533),
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff62b766), Color(0xff4fa553)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xff62b766).withOpacity(0.3),
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.person_add, color: Colors.white, size: 35),
        ),
        SizedBox(height: 20),
        Text(
          "Tạo tài khoản mới",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff2d5533),
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Gia nhập cộng đồng thể thao SprotHub",
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Username field
          _buildInputField(
            controller: username,
            hintText: "Tên tài khoản",
            icon: Icons.person_outline,
          ),

          SizedBox(height: 16),

          // Email field
          _buildInputField(
            controller: email,
            hintText: "Email của bạn",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 16),

          // Password field
          _buildInputField(
            controller: password,
            hintText: "Mật khẩu",
            icon: Icons.lock_outline,
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),

          SizedBox(height: 16),

          // Confirm Password field
          _buildInputField(
            controller: confirmPassword,
            hintText: "Xác nhận mật khẩu",
            icon: Icons.lock_outline,
            obscureText: !isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
          ),

          SizedBox(height: 16),

          // Terms agreement
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    agreeToTerms = !agreeToTerms;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: agreeToTerms
                        ? LinearGradient(
                            colors: [Color(0xff62b766), Color(0xff4fa553)],
                          )
                        : null,
                    color: agreeToTerms ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: agreeToTerms
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "Tôi đồng ý với ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Điều khoản",
                        style: TextStyle(
                          color: Color(0xff62b766),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: " và "),
                      TextSpan(
                        text: "Chính sách",
                        style: TextStyle(
                          color: Color(0xff62b766),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Register button
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff62b766), Color(0xff4fa553)],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff62b766).withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: agreeToTerms ? _handleRegister : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Đăng ký",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff8f9fa),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16, color: Color(0xff2d5533)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff62b766), Color(0xff4fa553)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Đã có tài khoản? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Đăng nhập ngay",
            style: TextStyle(
              color: Color(0xff62b766),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegister() async {
    // Register logic here
    print("Register with: ${username.text}, ${email.text}");
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
