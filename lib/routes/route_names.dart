// 📁 1. Route Names (Constants)
// ════════════════════════════════════════════════════════════════
// lib/core/routes/route_names.dart

/// Centralized route names - Single source of truth
class RouteNames {
  RouteNames._();

  // ═══════════════════════════════════════════════════════════════
  // Auth
  // ═══════════════════════════════════════════════════════════════
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // ═══════════════════════════════════════════════════════════════
  // Main App
  // ═══════════════════════════════════════════════════════════════
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // ═══════════════════════════════════════════════════════════════
  // Products
  // ═══════════════════════════════════════════════════════════════
  static const String products = '/products';
  static const String productDetail = '/product/:id';
  static String productDetailPath(String id) => '/product/$id';

  // ═══════════════════════════════════════════════════════════════
  // Categories
  // ═══════════════════════════════════════════════════════════════
  static const String categories = '/categories';
  static const String categoryDetail = '/category/:id';
  static String categoryDetailPath(String id) => '/category/$id';

  // ═══════════════════════════════════════════════════════════════
  // Cart & Orders
  // ═══════════════════════════════════════════════════════════════
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/order/:id';
  static String orderDetailPath(String id) => '/order/$id';

  // ═══════════════════════════════════════════════════════════════
  // Route Name Constants (for GoRouter.name)
  // ═══════════════════════════════════════════════════════════════
  // static const String splashName = 'splash';
  // static const String welcomeName = 'welcome';
  // static const String loginName = 'login';
  // static const String homeName = 'home';
  // static const String profileName = 'profile';
  // static const String productDetailName = 'productDetail';
  // static const String categoryDetailName = 'categoryDetail';
}
