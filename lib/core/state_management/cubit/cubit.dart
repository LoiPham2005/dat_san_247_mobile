// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/cubit/cubit.dart
// ════════════════════════════════════════════════════════════════

/// 🎯 CUBIT BASE CONFIGURATION
///
/// Export tất cả utilities, extensions, và helpers cho Cubit
///
/// Usage:
/// ```dart
/// import 'package:dat_san_247_mobile/core/state_management/cubit/cubit.dart';
/// ```
library;

export 'package:dat_san_247_mobile/core/errors/failures.dart';
// Re-export commonly used types
export 'package:dat_san_247_mobile/core/errors/result.dart';
export 'package:dat_san_247_mobile/core/state_management/base_status.dart';
export 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
// Extensions (reuse from bloc)
export 'package:dat_san_247_mobile/core/state_management/bloc/bloc_extensions.dart';
// Listeners (reuse from bloc)
export 'package:dat_san_247_mobile/core/state_management/bloc/bloc_listeners.dart';
// Core Bloc (Cubit is part of flutter_bloc)
export 'package:flutter_bloc/flutter_bloc.dart';

// Base classes
export 'base_cubit.dart';
