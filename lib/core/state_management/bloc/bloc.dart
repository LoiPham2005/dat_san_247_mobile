// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/bloc.dart
// ════════════════════════════════════════════════════════════════

/// 🎯 BLOC BASE CONFIGURATION
///
/// Export tất cả utilities, extensions, và helpers cho Bloc
///
/// Usage:
/// ```dart
/// import 'package:dat_san_247_mobile/core/state_management/bloc/bloc.dart';
/// ```

export 'package:dat_san_247_mobile/core/errors/failures.dart';
// Re-export commonly used types
export 'package:dat_san_247_mobile/core/errors/result.dart';
export 'package:dat_san_247_mobile/core/state_management/base_status.dart';
// Core Bloc
export 'package:flutter_bloc/flutter_bloc.dart';

// Base classes
export 'base_bloc.dart';
export 'base_event.dart';
export 'base_state.dart';
// Extensions
export 'bloc_extensions.dart';
// Listeners
export 'bloc_listeners.dart';
