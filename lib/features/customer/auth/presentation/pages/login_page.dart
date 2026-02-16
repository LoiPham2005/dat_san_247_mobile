// // login_page.dart
// import 'package:dat_san_247_mobile/core/extensions/context_extensions.dart';
// import 'package:dat_san_247_mobile/core/utils/validators.dart';
// import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';
// import 'package:dat_san_247_mobile/routes/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// // import '../../../bottomMenu/pages/bottom_menu_custom.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   bool isPasswordVisible = false;
//   bool rememberMe = false;
//   // final controller = Get.find<AuthController>();

//   late AnimationController _slideController;
//   late AnimationController _fadeController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

//     _slideController.forward();
//     _fadeController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               const Color(0xff62b766).withOpacity(0.1),
//               Colors.white,
//               const Color(0xff4fa553).withOpacity(0.05),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),

//                   // Header with back button and logo
//                   _buildHeader(),

//                   const SizedBox(height: 40),

//                   // Welcome section
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(opacity: _fadeAnimation, child: _buildWelcomeSection()),
//                   ),

//                   const SizedBox(height: 40),

//                   // Form section
//                   SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(opacity: _fadeAnimation, child: _buildFormSection()),
//                   ),

//                   const SizedBox(height: 30),

//                   // Footer
//                   _buildFooter(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Icon(Icons.arrow_back_ios_new, color: Color(0xff2d5533), size: 20),
//           ),
//         ),
//         const Spacer(),
//         Row(
//           children: [
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(colors: [Color(0xff62b766), Color(0xff4fa553)]),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.sports_soccer, color: Colors.white, size: 18),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               "SprotHub",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2d5533)),
//             ),
//           ],
//         ),
//         const Spacer(),
//       ],
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(colors: [Color(0xff62b766), Color(0xff4fa553)]),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xff62b766).withOpacity(0.3),
//                 blurRadius: 16,
//                 spreadRadius: 2,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: const Icon(Icons.sports_tennis, color: Colors.white, size: 40),
//         ),
//         const SizedBox(height: 24),
//         const Text(
//           "Chào mừng trở lại!",
//           style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff2d5533)),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Đăng nhập để tiếp tục hành trình thể thao",
//           style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildFormSection() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Email field
//           _buildInputField(
//             controller: email,
//             hintText: "Email của bạn",
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//           ),

//           const SizedBox(height: 16),

//           // Password field
//           _buildInputField(
//             controller: password,
//             hintText: "Mật khẩu",
//             icon: Icons.lock_outline,
//             isPassword: true,
//             obscureText: !isPasswordVisible,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey[600],
//               ),
//               onPressed: () {
//                 setState(() {
//                   isPasswordVisible = !isPasswordVisible;
//                 });
//               },
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Remember & Forgot password
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     rememberMe = !rememberMe;
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       width: 20,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         gradient: rememberMe
//                             ? const LinearGradient(colors: [Color(0xff62b766), Color(0xff4fa553)])
//                             : null,
//                         color: rememberMe ? null : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: rememberMe
//                           ? const Icon(Icons.check, color: Colors.white, size: 14)
//                           : null,
//                     ),
//                     const SizedBox(width: 8),
//                     Text("Ghi nhớ", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to forgot password
//                 },
//                 child: const Text(
//                   "Quên mật khẩu?",
//                   style: TextStyle(
//                     color: Color(0xff62b766),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           // Login button
//           Container(
//             width: double.infinity,
//             height: 52,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(colors: [Color(0xff62b766), Color(0xff4fa553)]),
//               borderRadius: BorderRadius.circular(26),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xff62b766).withOpacity(0.4),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: ElevatedButton(
//               onPressed: _handleLogin,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.login, color: Colors.white, size: 20),
//                   const SizedBox(width: 8),
//                   InkWell(
//                     onTap: _handleLogin,
//                     child: const Text(
//                       "Đăng nhập",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool isPassword = false,
//     bool obscureText = false,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xfff8f9fa),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         style: const TextStyle(fontSize: 16, color: Color(0xff2d5533)),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
//           prefixIcon: Container(
//             margin: const EdgeInsets.all(12),
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(colors: [Color(0xff62b766), Color(0xff4fa553)]),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Icon(icon, color: Colors.white, size: 16),
//           ),
//           suffixIcon: suffixIcon,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Column(
//       children: [
//         // Divider
//         Row(
//           children: [
//             Expanded(child: Divider(color: Colors.grey[300])),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text("Hoặc", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
//             ),
//             Expanded(child: Divider(color: Colors.grey[300])),
//           ],
//         ),

//         const SizedBox(height: 20),

//         // Social login buttons
//         Row(
//           children: [
//             Expanded(
//               child: _buildSocialButton(
//                 icon: Icons.g_mobiledata,
//                 label: 'Google',
//                 color: const Color(0xffdb4437),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildSocialButton(
//                 icon: Icons.facebook,
//                 label: 'Facebook',
//                 color: const Color(0xff4267b2),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 24),

//         // Register link
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Chưa có tài khoản? ", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
//             GestureDetector(
//               onTap: () {
//                 // Go .to(
//                 //   () => const RegisterPage(),
//                 //   curve: Curves.easeInOut,
//                 //   transition: Transition.rightToLeftWithFade,
//                 // );
//                 context.navPush(RegisterPage());
//               },
//               child: const Text(
//                 'Đăng ký ngay',
//                 style: TextStyle(
//                   color: Color(0xff62b766),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildSocialButton({required IconData icon, required String label, required Color color}) {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: color, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleLogin() async {
//     final emailText = email.text.trim();
//     final passwordText = password.text.trim();

//     final message = Validators.loginForm(email: emailText, password: passwordText);

//     // if (message != null) {
//     //   // Get.snackbar(
//     //   //   "Thông báo",
//     //   //   message,
//     //   //   snackPosition: SnackPosition.BOTTOM,
//     //   //   backgroundColor: Colors.red,
//     //   //   colorText: Colors.white,
//     //   // );
//     //
//     //   return;
//     // }

//     context.go(RouteNames.home);

//     context.showSuccessSnackBar("Đăng nhập thành công");

//     // final success = await controller.login(emailText, passwordText);
//     // if (success) {
//     //   Get.offAll(() => const BottomMenuCustom(), transition: Transition.fade);
//     //   Get.snackbar(
//     //     "Thông báo",
//     //     "Đăng nhập  thành công",
//     //     backgroundColor: Colors.green,
//     //     colorText: Colors.white,
//     //   );
//     // } else {
//     //   Get.snackbar(
//     //     "Thông báo",
//     //     "Đăng nhập không thành công",
//     //     snackPosition: SnackPosition.BOTTOM,
//     //     backgroundColor: Colors.red,
//     //     colorText: Colors.white,
//     //   );
//     // }
//   }

//   @override
//   void dispose() {
//     email.dispose();
//     password.dispose();
//     _slideController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }
// }
