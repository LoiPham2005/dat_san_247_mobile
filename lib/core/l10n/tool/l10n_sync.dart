// // tool/l10n_sync.dart
// import 'dart:convert';
// import 'dart:io';

// void main(List<String> arguments) async {
//   final syncer = L10nSyncer();
//   await syncer.sync(
//     dryRun: arguments.contains('--dry-run'),
//     verbose: arguments.contains('--verbose'),
//   );
// }

// class L10nSyncer {
//   static const _l10nPath = 'lib/core/l10n/translations';
//   static const _sourceFile = 'app_en.arb';
//   static const _indent = '  ';

//   // Colors for console output
//   static const _green = '\x1B[32m';
//   static const _yellow = '\x1B[33m';
//   static const _red = '\x1B[31m';
//   static const _blue = '\x1B[34m';
//   static const _reset = '\x1B[0m';

//   Future<void> sync({bool dryRun = false, bool verbose = false}) async {
//     print(
//       '$_blue════════════════════════════════════════════════════════$_reset',
//     );
//     print('$_blue🌍 L10n Sync Tool${dryRun ? ' (DRY RUN)' : ''}$_reset');
//     print(
//       '$_blue════════════════════════════════════════════════════════$_reset\n',
//     );

//     try {
//       // 1. Validate l10n directory
//       final l10nDir = Directory(_l10nPath);
//       if (!l10nDir.existsSync()) {
//         _error('Directory not found: $_l10nPath');
//         exit(1);
//       }

//       // 2. Load source file (app_en.arb)
//       final sourceFile = File('$_l10nPath/$_sourceFile');
//       if (!sourceFile.existsSync()) {
//         _error('Source file not found: $_sourceFile');
//         exit(1);
//       }

//       final sourceContent = _loadArb(sourceFile);
//       final sourceKeys = _extractTranslationKeys(sourceContent);

//       _info('Source file: $_sourceFile (${sourceKeys.length} keys)');
//       if (verbose) {
//         _printKeys(sourceKeys, '  ');
//       }
//       print('');

//       // 3. Find target files
//       final targetFiles = _findTargetFiles(l10nDir);
//       if (targetFiles.isEmpty) {
//         _warning('No target files found');
//         exit(0);
//       }

//       _info('Found ${targetFiles.length} target file(s):\n');

//       // 4. Process each target file
//       var totalAdded = 0;
//       var totalRemoved = 0;
//       var totalUpdated = 0;

//       for (final file in targetFiles) {
//         final result = await _processFile(
//           file,
//           sourceContent,
//           sourceKeys,
//           dryRun: dryRun,
//           verbose: verbose,
//         );

//         totalAdded += result.added;
//         totalRemoved += result.removed;
//         totalUpdated += result.updated;
//       }

//       // 5. Summary
//       print(
//         '\n$_blue════════════════════════════════════════════════════════$_reset',
//       );
//       print('$_green✅ Sync completed!$_reset\n');
//       print('  Added:   $_green$totalAdded$_reset keys');
//       print('  Removed: $_red$totalRemoved$_reset keys');
//       print('  Updated: $_yellow$totalUpdated$_reset metadata');

//       if (dryRun) {
//         print('\n$_yellow⚠️  DRY RUN: No files were modified$_reset');
//       }
//       print(
//         '$_blue════════════════════════════════════════════════════════$_reset',
//       );
//     } catch (e, stackTrace) {
//       _error('Fatal error: $e');
//       if (verbose) {
//         print(stackTrace);
//       }
//       exit(1);
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Process single file
//   // ═══════════════════════════════════════════════════════════════

//   Future<SyncResult> _processFile(
//     File file,
//     Map<String, dynamic> sourceContent,
//     Set<String> sourceKeys, {
//     required bool dryRun,
//     required bool verbose,
//   }) async {
//     final fileName = file.path.split('/').last;
//     print('$_blue📄 $fileName$_reset');

//     final targetContent = _loadArb(file);
//     final targetKeys = _extractTranslationKeys(targetContent);

//     final added = <String>[];
//     final removed = <String>[];
//     final updated = <String>[];

//     // Find missing keys (in source but not in target)
//     for (final key in sourceKeys) {
//       if (!targetKeys.contains(key)) {
//         targetContent[key] = sourceContent[key];
//         added.add(key);
//       }
//     }

//     // Find extra keys (in target but not in source) - Remove them
//     for (final key in targetKeys) {
//       if (!sourceKeys.contains(key)) {
//         targetContent.remove(key);
//         removed.add(key);
//       }
//     }

//     // Sync metadata (@-prefixed keys)
//     for (final key in sourceContent.keys) {
//       if (key.startsWith('@')) {
//         final baseKey = key.substring(1);
//         if (targetKeys.contains(baseKey)) {
//           // Update metadata for existing translations
//           targetContent[key] = sourceContent[key];
//           if (verbose) {
//             updated.add(key);
//           }
//         }
//       }
//     }

//     // Sort keys (translations first, then metadata)
//     final sortedContent = _sortArbContent(targetContent);

//     // Print changes
//     if (added.isNotEmpty) {
//       print('  $_green+ Added: ${added.length}$_reset');
//       if (verbose) {
//         for (final key in added) {
//           print('    $_green+ $key$_reset');
//         }
//       }
//     }

//     if (removed.isNotEmpty) {
//       print('  $_red- Removed: ${removed.length}$_reset');
//       if (verbose) {
//         for (final key in removed) {
//           print('    $_red- $key$_reset');
//         }
//       }
//     }

//     if (updated.isNotEmpty && verbose) {
//       print('  $_yellow~ Updated metadata: ${updated.length}$_reset');
//     }

//     if (added.isEmpty && removed.isEmpty && updated.isEmpty) {
//       print('  $_green✓ Already in sync$_reset');
//     }

//     // Write file
//     if (!dryRun &&
//         (added.isNotEmpty || removed.isNotEmpty || updated.isNotEmpty)) {
//       _writeArb(file, sortedContent);
//       print('  $_green✓ Saved$_reset');
//     }

//     print('');

//     return SyncResult(
//       added: added.length,
//       removed: removed.length,
//       updated: updated.length,
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Helper methods
//   // ═══════════════════════════════════════════════════════════════

//   List<File> _findTargetFiles(Directory dir) {
//     return dir
//         .listSync()
//         .whereType<File>()
//         .where((f) => f.path.endsWith('.arb') && !f.path.endsWith(_sourceFile))
//         .toList()
//       ..sort((a, b) => a.path.compareTo(b.path));
//   }

//   Map<String, dynamic> _loadArb(File file) {
//     try {
//       final content = file.readAsStringSync();
//       return jsonDecode(content) as Map<String, dynamic>;
//     } catch (e) {
//       _error('Failed to parse ${file.path}: $e');
//       exit(1);
//     }
//   }

//   void _writeArb(File file, Map<String, dynamic> content) {
//     try {
//       final json = JsonEncoder.withIndent(_indent).convert(content);
//       file.writeAsStringSync('$json\n'); // Add trailing newline
//     } catch (e) {
//       _error('Failed to write ${file.path}: $e');
//       exit(1);
//     }
//   }

//   Set<String> _extractTranslationKeys(Map<String, dynamic> content) {
//     return content.keys.where((key) => !key.startsWith('@')).toSet();
//   }

//   Map<String, dynamic> _sortArbContent(Map<String, dynamic> content) {
//     final sorted = <String, dynamic>{};

//     // First, add all translation keys (sorted)
//     final translationKeys =
//         content.keys.where((k) => !k.startsWith('@')).toList()..sort();
//     for (final key in translationKeys) {
//       sorted[key] = content[key];

//       // Add metadata if exists
//       final metaKey = '@$key';
//       if (content.containsKey(metaKey)) {
//         sorted[metaKey] = content[metaKey];
//       }
//     }

//     return sorted;
//   }

//   void _printKeys(Set<String> keys, String prefix) {
//     for (final key in keys.toList()..sort()) {
//       print('$prefix- $key');
//     }
//   }

//   void _info(String message) => print('$_blue$message$_reset');
//   void _warning(String message) => print('$_yellow⚠️  $message$_reset');
//   void _error(String message) => print('$_red❌ $message$_reset');
// }

// class SyncResult {
//   const SyncResult({
//     required this.added,
//     required this.removed,
//     required this.updated,
//   });

//   final int added;
//   final int removed;
//   final int updated;
// }




// ════════════════════════════════════════════════════════════════
// 📁 tool/l10n_sync.dart (UPGRADED with ansicolor)
// ════════════════════════════════════════════════════════════════
import 'dart:convert';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

void main(List<String> arguments) async {
  // Enable ANSI colors for all platforms
  ansiColorDisabled = false;

  final syncer = L10nSyncer();
  await syncer.sync(
    dryRun: arguments.contains('--dry-run'),
    verbose: arguments.contains('--verbose'),
  );
}

class L10nSyncer {
  static const _l10nPath = 'lib/core/l10n/translations';
  static const _sourceFile = 'app_en.arb';
  static const _indent = '  ';

  // ═══════════════════════════════════════════════════════════════
  // Color pens (Clean & Maintainable)
  // ═══════════════════════════════════════════════════════════════
  static final _green = AnsiPen()..green();
  static final _yellow = AnsiPen()..yellow();
  static final _red = AnsiPen()..red();
  static final _blue = AnsiPen()..blue();
  static final _cyan = AnsiPen()..cyan();
  static final _magenta = AnsiPen()..magenta();
  static final _gray = AnsiPen()..gray();

  // Bright/bold variants (using xterm method)
  static final _greenBold = AnsiPen()..green(bold: true);
  static final _redBold = AnsiPen()..red(bold: true);
  static final _blueBold = AnsiPen()..blue(bold: true);
  static final _yellowBold = AnsiPen()..yellow(bold: true);

  // ═══════════════════════════════════════════════════════════════
  // Main sync method
  // ═══════════════════════════════════════════════════════════════
  Future<void> sync({bool dryRun = false, bool verbose = false}) async {
    _printHeader(dryRun);

    try {
      // 1. Validate l10n directory
      final l10nDir = Directory(_l10nPath);
      if (!l10nDir.existsSync()) {
        _error('Directory not found: $_l10nPath');
        exit(1);
      }

      // 2. Load source file (app_en.arb)
      final sourceFile = File('$_l10nPath/$_sourceFile');
      if (!sourceFile.existsSync()) {
        _error('Source file not found: $_sourceFile');
        exit(1);
      }

      final sourceContent = _loadArb(sourceFile);
      final sourceKeys = _extractTranslationKeys(sourceContent);

      _info('Source file: ${_cyan(_sourceFile)} '
          '(${_greenBold('${sourceKeys.length}')} keys)');
      if (verbose) {
        _printKeys(sourceKeys, '  ');
      }
      print('');

      // 3. Find target files
      final targetFiles = _findTargetFiles(l10nDir);
      if (targetFiles.isEmpty) {
        _warning('No target files found');
        exit(0);
      }

      _info('Found ${_cyan('${targetFiles.length}')} target file(s):\n');

      // 4. Process each target file
      var totalAdded = 0;
      var totalRemoved = 0;
      var totalUpdated = 0;

      for (final file in targetFiles) {
        final result = await _processFile(
          file,
          sourceContent,
          sourceKeys,
          dryRun: dryRun,
          verbose: verbose,
        );

        totalAdded += result.added;
        totalRemoved += result.removed;
        totalUpdated += result.updated;
      }

      // 5. Summary
      _printSummary(totalAdded, totalRemoved, totalUpdated, dryRun);
    } catch (e, stackTrace) {
      _error('Fatal error: $e');
      if (verbose) {
        print(_gray(stackTrace.toString()));
      }
      exit(1);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Process single file
  // ═══════════════════════════════════════════════════════════════
  Future<SyncResult> _processFile(
    File file,
    Map<String, dynamic> sourceContent,
    Set<String> sourceKeys, {
    required bool dryRun,
    required bool verbose,
  }) async {
    final fileName = file.path.split('/').last;
    print(_blueBold('📄 $fileName'));

    final targetContent = _loadArb(file);
    final targetKeys = _extractTranslationKeys(targetContent);

    final added = <String>[];
    final removed = <String>[];
    final updated = <String>[];

    // Find missing keys (in source but not in target)
    for (final key in sourceKeys) {
      if (!targetKeys.contains(key)) {
        targetContent[key] = sourceContent[key];
        added.add(key);
      }
    }

    // Find extra keys (in target but not in source) - Remove them
    for (final key in targetKeys) {
      if (!sourceKeys.contains(key)) {
        targetContent.remove(key);
        removed.add(key);
      }
    }

    // Sync metadata (@-prefixed keys)
    for (final key in sourceContent.keys) {
      if (key.startsWith('@')) {
        final baseKey = key.substring(1);
        if (targetKeys.contains(baseKey)) {
          targetContent[key] = sourceContent[key];
          if (verbose) {
            updated.add(key);
          }
        }
      }
    }

    // Sort keys (translations first, then metadata)
    final sortedContent = _sortArbContent(targetContent);

    // Print changes
    if (added.isNotEmpty) {
      print('  ${_green('+ Added: ${added.length}')}');
      if (verbose) {
        for (final key in added) {
          print('    ${_green('+ $key')}');
        }
      }
    }

    if (removed.isNotEmpty) {
      print('  ${_red('- Removed: ${removed.length}')}');
      if (verbose) {
        for (final key in removed) {
          print('    ${_red('- $key')}');
        }
      }
    }

    if (updated.isNotEmpty && verbose) {
      print('  ${_yellow('~ Updated metadata: ${updated.length}')}');
    }

    if (added.isEmpty && removed.isEmpty && updated.isEmpty) {
      print('  ${_green('✓ Already in sync')}');
    }

    // Write file
    if (!dryRun &&
        (added.isNotEmpty || removed.isNotEmpty || updated.isNotEmpty)) {
      _writeArb(file, sortedContent);
      print('  ${_green('✓ Saved')}');
    }

    print('');

    return SyncResult(
      added: added.length,
      removed: removed.length,
      updated: updated.length,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Helper methods
  // ═══════════════════════════════════════════════════════════════
  List<File> _findTargetFiles(Directory dir) {
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb') && !f.path.endsWith(_sourceFile))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
  }

  Map<String, dynamic> _loadArb(File file) {
    try {
      final content = file.readAsStringSync();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      _error('Failed to parse ${file.path}: $e');
      exit(1);
    }
  }

  void _writeArb(File file, Map<String, dynamic> content) {
    try {
      final json = JsonEncoder.withIndent(_indent).convert(content);
      file.writeAsStringSync('$json\n'); // Add trailing newline
    } catch (e) {
      _error('Failed to write ${file.path}: $e');
      exit(1);
    }
  }

  Set<String> _extractTranslationKeys(Map<String, dynamic> content) {
    return content.keys.where((key) => !key.startsWith('@')).toSet();
  }

  Map<String, dynamic> _sortArbContent(Map<String, dynamic> content) {
    final sorted = <String, dynamic>{};

    // First, add all translation keys (sorted)
    final translationKeys =
        content.keys.where((k) => !k.startsWith('@')).toList()..sort();
    for (final key in translationKeys) {
      sorted[key] = content[key];

      // Add metadata if exists
      final metaKey = '@$key';
      if (content.containsKey(metaKey)) {
        sorted[metaKey] = content[metaKey];
      }
    }

    return sorted;
  }

  void _printKeys(Set<String> keys, String prefix) {
    for (final key in keys.toList()..sort()) {
      print('$prefix${_gray('- $key')}');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Output methods with colors
  // ═══════════════════════════════════════════════════════════════
  void _printHeader(bool dryRun) {
    final border = '═' * 60;
    print(_blue(border));
    print(_blueBold('🌍 L10n Sync Tool${dryRun ? ' (DRY RUN)' : ''}'));
    print(_blue(border));
    print('');
  }

  void _printSummary(int added, int removed, int updated, bool dryRun) {
    final border = '═' * 60;
    print(_blue(border));
    print(_greenBold('✅ Sync completed!'));
    print('');
    print('  Added:   ${_green('$added')} keys');
    print('  Removed: ${_red('$removed')} keys');
    print('  Updated: ${_yellow('$updated')} metadata');

    if (dryRun) {
      print('');
      print(_yellowBold('⚠️  DRY RUN: No files were modified'));
    }
    print(_blue(border));
  }

  void _info(String message) => print(_blue('ℹ️  $message'));
  void _warning(String message) => print(_yellow('⚠️  $message'));
  void _error(String message) => print(_redBold('❌ $message'));
}

class SyncResult {
  const SyncResult({
    required this.added,
    required this.removed,
    required this.updated,
  });

  final int added;
  final int removed;
  final int updated;
}
