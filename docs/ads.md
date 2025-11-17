// ════════════════════════════════════════════════════════════════
// 🚀 6. Usage Examples
// ════════════════════════════════════════════════════════════════

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ListView()),
          // ✅ Smart banner with Remote Config control
          const SmartBannerAdWidget(screenName: 'home'),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// 📊 REAL-WORLD SCENARIOS
// ════════════════════════════════════════════════════════════════

// ✅ Scenario 1: App bị Policy Violation
// Static Config:
// - Phải submit app update → 2-7 days review
// - User vẫn thấy ads vi phạm
// - Revenue bị stop
//
// Remote Config:
// - Set ads_enabled = false trong Firebase
// - Tắt ngay lập tức trong vài giây
// - Fix policy issue, rồi bật lại

// ✅ Scenario 2: Users complain quá nhiều ads
// Static Config:
// - Code lại frequency
// - Submit app update
// - Đợi review
//
// Remote Config:
// - Set interstitial_frequency = 5 (thay vì 3)
// - Apply ngay lập tức
// - A/B test giá trị tốt nhất

// ✅ Scenario 3: Ad Unit ID bị ban
// Static Config:
// - Update hardcoded ID
// - Submit app → 2-7 days
// - Revenue loss
//
// Remote Config:
// - Set android_banner_id = "new_id"
// - Apply trong vài giây
// - No revenue loss

// ✅ Scenario 4: Test aggressive strategy
// Static Config:
// - Không test được
// - Hoặc phải publish 2 versions
//
// Remote Config:
// - Set ad_strategy = "aggressive" cho 10% users
// - Monitor metrics
// - Rollout nếu tốt, rollback nếu xấu

// ════════════════════════════════════════════════════════════════
// 🎯 KẾT LUẬN
// ════════════════════════════════════════════════════════════════

// ✅ KHUYẾN NGHỊ MẠNH: Remote Config Architecture
//
// Lý do:
// 1. ✅ Kiểm soát hoàn toàn từ xa (no app update)
// 2. ✅ Kill switch khẩn cấp
// 3. ✅ A/B testing dễ dàng
// 4. ✅ Dynamic Ad IDs
// 5. ✅ Instant rollback
// 6. ✅ Cost saving (no repeated submissions)
// 7. ✅ Better user experience
// 8. ✅ Data-driven decisions
//
// ❌ Static Config chỉ phù hợp khi:
// - Prototype/MVP nhỏ
// - Không cần flexibility
// - Team không có Firebase
//
// 💰 ROI:
// - Setup time: +2 hours
// - Time saved per year: 100+ hours
// - Revenue protection: Priceless
// - User satisfaction: Higher

// ════════════════════════════════════════════════════════════════
// 🔥 FIREBASE CONSOLE SETUP
// ════════════════════════════════════════════════════════════════

// Go to Firebase Console > Remote Config > Add parameters:
//
// ads_enabled              = true    (Boolean)
// banner_enabled           = true    (Boolean)
// interstitial_enabled     = true    (Boolean)
// android_banner_id        = ca-app-pub-... (String)
// ios_banner_id            = ca-app-pub-... (String)
// interstitial_frequency   = 3       (Number)
// interstitial_cooldown_seconds = 300 (Number)
// show_banner_on_home      = true    (Boolean)
// ad_strategy              = default (String)
// test_mode                = false   (Boolean)

// 💡 Tip: Use Conditions for A/B testing:
// - Version 1.0: interstitial_frequency = 3
// - Version 1.1: interstitial_frequency = 5
// - New users: ad_strategy = "minimal"
// - Power users: ad_strategy = "aggressive"
