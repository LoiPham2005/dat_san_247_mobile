// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/riverpod.dart
// ════════════════════════════════════════════════════════════════

/// 🎯 RIVERPOD BASE CONFIGURATION
///
/// Export tất cả utilities, extensions, và helpers cho Riverpod
///
/// Usage:
/// ```dart
/// import 'package:dat_san_247_mobile/core/state_management/riverpod/riverpod.dart';
/// ```

export 'package:dat_san_247_mobile/core/errors/failures.dart';
// Re-export commonly used types
export 'package:dat_san_247_mobile/core/errors/result.dart';
// Core Riverpod
export 'package:flutter_riverpod/flutter_riverpod.dart';

// Base classes
export 'base_async_notifier.dart';
// Helper functions
export 'result_handler.dart';
// Extensions
// Listeners
export 'riverpod_listeners.dart';
