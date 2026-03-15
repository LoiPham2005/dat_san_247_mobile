// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state/cubit/cubit.dart
// ════════════════════════════════════════════════════════════════

/// 🎯 CUBIT BASE CONFIGURATION
///
/// Export tất cả utilities, extensions, và helpers cho Cubit
///
/// Usage:
/// ```dart
/// import 'package:dat_san_247_mobile/core/state/cubit/cubit.dart';
/// ```
library;

export '../../errors/failures.dart';
// Re-export commonly used types
export '../../errors/result.dart';
export '../base_status.dart';
// Extensions (reuse from bloc)
export '../bloc/auto_bloc/bloc_extensions.dart';
export '../bloc/base_state.dart';
// Listeners (reuse from bloc)
export '../bloc/bloc_listeners.dart';
// Core Bloc (Cubit is part of flutter_bloc)
export 'package:flutter_bloc/flutter_bloc.dart';

// Base classes
export 'base_cubit.dart';
