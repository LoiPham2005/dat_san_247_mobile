
// // ════════════════════════════════════════════════════════════════
// // 🌍 L10N SYNC + AUTO TRANSLATION - PRODUCTION READY
// // ════════════════════════════════════════════════════════════════
// // Features:
// // - Sync keys from app_en.arb to other languages
// // - Auto-translate missing values using Google Translate API
// // - Smart caching to avoid re-translating
// // - Fallback to English if translation fails
// // ════════════════════════════════════════════════════════════════

// // tool/l10n_sync.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// void main(List<String> arguments) async {
//   final syncer = L10nSyncer();
//   await syncer.sync(
//     dryRun: arguments.contains('--dry-run'),
//     verbose: arguments.contains('--verbose'),
//     translate: arguments.contains('--translate'), // ✅ NEW FLAG
//   );
// }

// class L10nSyncer {
//   static const _l10nPath = 'lib/core/l10n/translations';
//   static const _sourceFile = 'app_en.arb';
//   static const _indent = '  ';

//   // ✅ Language mapping (ARB locale -> Google Translate code)
//   static const _languageMap = {
//     'app_vi.arb': 'vi',  // Vietnamese
//     'app_ja.arb': 'ja',  // Japanese
//     'app_ko.arb': 'ko',  // Korean
//     'app_zh.arb': 'zh',  // Chinese
//     'app_es.arb': 'es',  // Spanish
//     'app_fr.arb': 'fr',  // French
//     'app_de.arb': 'de',  // German
//     'app_ar.arb': 'ar',  // Arabic
//     'app_th.arb': 'th',  // Thai
//     'app_id.arb': 'id',  // Indonesian
//   };

//   // Console colors
//   static const _green = '\x1B[32m';
//   static const _yellow = '\x1B[33m';
//   static const _red = '\x1B[31m';
//   static const _blue = '\x1B[34m';
//   static const _cyan = '\x1B[36m';
//   static const _reset = '\x1B[0m';

//   Future<void> sync({
//     bool dryRun = false,
//     bool verbose = false,
//     bool translate = false,
//   }) async {
//     print('$_blue════════════════════════════════════════════════════════$_reset');
//     print('$_blue🌍 L10n Sync Tool${dryRun ? ' (DRY RUN)' : ''}${translate ? ' + Translation' : ''}$_reset');
//     print('$_blue════════════════════════════════════════════════════════$_reset\n');

//     try {
//       // 1. Validate
//       final l10nDir = Directory(_l10nPath);
//       if (!l10nDir.existsSync()) {
//         _error('Directory not found: $_l10nPath');
//         exit(1);
//       }

//       // 2. Load source
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

//       // 3. Find targets
//       final targetFiles = _findTargetFiles(l10nDir);
//       if (targetFiles.isEmpty) {
//         _warning('No target files found');
//         exit(0);
//       }

//       _info('Found ${targetFiles.length} target file(s):\n');

//       // 4. Process files
//       var totalAdded = 0;
//       var totalRemoved = 0;
//       var totalTranslated = 0;

//       for (final file in targetFiles) {
//         final result = await _processFile(
//           file,
//           sourceContent,
//           sourceKeys,
//           dryRun: dryRun,
//           verbose: verbose,
//           translate: translate,
//         );

//         totalAdded += result.added;
//         totalRemoved += result.removed;
//         totalTranslated += result.translated;
//       }

//       // 5. Summary
//       print('\n$_blue════════════════════════════════════════════════════════$_reset');
//       print('$_green✅ Sync completed!$_reset\n');
//       print('  Added:      $_green$totalAdded$_reset keys');
//       print('  Removed:    $_red$totalRemoved$_reset keys');
//       if (translate) {
//         print('  Translated: $_cyan$totalTranslated$_reset keys');
//       }

//       if (dryRun) {
//         print('\n$_yellow⚠️  DRY RUN: No files were modified$_reset');
//       }
//       print('$_blue════════════════════════════════════════════════════════$_reset');
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
//     required bool translate,
//   }) async {
//     final fileName = file.path.split('/').last;
//     print('$_blue📄 $fileName$_reset');

//     final targetContent = _loadArb(file);
//     final targetKeys = _extractTranslationKeys(targetContent);
//     final targetLang = _languageMap[fileName];

//     final added = <String>[];
//     final removed = <String>[];
//     var translated = 0;

//     // Add missing keys or translate English values
//     for (final key in sourceKeys) {
//       final sourceValue = sourceContent[key] as String;
//       final isNewKey = !targetKeys.contains(key);
//       final currentValue = targetContent[key] as String?;

//       // ✅ Translate if:
//       // 1. New key (doesn't exist)
//       // 2. Value is same as English (not translated yet)
//       final needsTranslation = isNewKey || (currentValue == sourceValue);

//       if (needsTranslation) {
//         // ✅ Auto-translate if enabled
//         if (translate && targetLang != null) {
//           try {
//             if (verbose || isNewKey) {
//               print('  $_cyan🔄 Translating "$key": "$sourceValue"$_reset');
//             }

//             final translatedValue = await _translate(
//               sourceValue,
//               targetLang,
//             );

//             targetContent[key] = translatedValue;
//             translated++;

//             if (verbose) {
//               print('    $_cyan✓ "$sourceValue" → "$translatedValue"$_reset');
//             }
//           } catch (e) {
//             if (verbose) {
//               _warning('Translation failed for "$key", using English');
//             }
//             targetContent[key] = sourceValue; // Fallback to English
//           }
//         } else {
//           // No translation, use English
//           targetContent[key] = sourceValue;
//         }

//         if (isNewKey) {
//           added.add(key);
//         }
//       }
//     }

//     // Remove extra keys
//     for (final key in targetKeys) {
//       if (!sourceKeys.contains(key)) {
//         targetContent.remove(key);
//         removed.add(key);
//       }
//     }

//     // Sync metadata
//     for (final key in sourceContent.keys) {
//       if (key.startsWith('@')) {
//         final baseKey = key.substring(1);
//         if (targetContent.containsKey(baseKey)) {
//           targetContent[key] = sourceContent[key];
//         }
//       }
//     }

//     // Sort
//     final sortedContent = _sortArbContent(targetContent);

//     // Print changes
//     if (added.isNotEmpty) {
//       print('  $_green+ Added: ${added.length}$_reset');
//       if (verbose && !translate) {
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

//     if (translated > 0) {
//       print('  $_cyan🌐 Translated: $translated$_reset');
//     }

//     if (added.isEmpty && removed.isEmpty) {
//       print('  $_green✓ Already in sync$_reset');
//     }

//     // Write
//     if (!dryRun && (added.isNotEmpty || removed.isNotEmpty)) {
//       _writeArb(file, sortedContent);
//       print('  $_green✓ Saved$_reset');
//     }

//     print('');

//     return SyncResult(
//       added: added.length,
//       removed: removed.length,
//       translated: translated,
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // Translation API
//   // ═══════════════════════════════════════════════════════════════

//   Future<String> _translate(String text, String targetLang) async {
//     // ✅ Option 1: Google Translate API (Free - No API Key)
//     // Uses unofficial endpoint (rate limited)
//     return await _translateGoogleFree(text, targetLang);

//     // ✅ Option 2: Google Translate API (Official - Requires API Key)
//     // Uncomment and add your API key
//     // return await _translateGoogleOfficial(text, targetLang);

//     // ✅ Option 3: LibreTranslate (Free & Open Source)
//     // return await _translateLibre(text, targetLang);
//   }

//   // Free Google Translate (No API key)
//   Future<String> _translateGoogleFree(String text, String targetLang) async {
//     // Skip placeholders
//     if (text.contains('{') && text.contains('}')) {
//       _warning('Skipping translation for text with placeholders: $text');
//       return text;
//     }

//     try {
//       final url = Uri.parse(
//         'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$targetLang&dt=t&q=${Uri.encodeComponent(text)}',
//       );

//       final response = await http.get(url).timeout(
//         const Duration(seconds: 10),
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         final translated = decoded[0][0][0] as String;
//         return translated;
//       } else {
//         throw Exception('HTTP ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Translation failed: $e');
//     }
//   }

//   // Official Google Translate API (Requires API key)
//   Future<String> _translateGoogleOfficial(String text, String targetLang) async {
//     const apiKey = 'YOUR_GOOGLE_TRANSLATE_API_KEY'; // ⚠️ Add your key

//     if (apiKey == 'YOUR_GOOGLE_TRANSLATE_API_KEY') {
//       throw Exception('Google Translate API key not configured');
//     }

//     final url = Uri.parse(
//       'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
//     );

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'q': text,
//         'source': 'en',
//         'target': targetLang,
//         'format': 'text',
//       }),
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       return decoded['data']['translations'][0]['translatedText'];
//     } else {
//       throw Exception('HTTP ${response.statusCode}');
//     }
//   }

//   // LibreTranslate (Free & Open Source)
//   Future<String> _translateLibre(String text, String targetLang) async {
//     final url = Uri.parse('https://libretranslate.de/translate');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'q': text,
//         'source': 'en',
//         'target': targetLang,
//         'format': 'text',
//       }),
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       return decoded['translatedText'];
//     } else {
//       throw Exception('HTTP ${response.statusCode}');
//     }
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
//       file.writeAsStringSync('$json\n');
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
//     final translationKeys = content.keys.where((k) => !k.startsWith('@')).toList()..sort();

//     for (final key in translationKeys) {
//       sorted[key] = content[key];
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
//     required this.translated,
//   });

//   final int added;
//   final int removed;
//   final int translated;
// }









// tool/l10n_sync.dart
import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
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

  // Colors for console output
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _blue = '\x1B[34m';
  static const _reset = '\x1B[0m';

  Future<void> sync({
    bool dryRun = false,
    bool verbose = false,
  }) async {
    print('$_blue════════════════════════════════════════════════════════$_reset');
    print('$_blue🌍 L10n Sync Tool${dryRun ? ' (DRY RUN)' : ''}$_reset');
    print('$_blue════════════════════════════════════════════════════════$_reset\n');

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

      _info('Source file: $_sourceFile (${sourceKeys.length} keys)');
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

      _info('Found ${targetFiles.length} target file(s):\n');

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
      print('\n$_blue════════════════════════════════════════════════════════$_reset');
      print('$_green✅ Sync completed!$_reset\n');
      print('  Added:   $_green$totalAdded$_reset keys');
      print('  Removed: $_red$totalRemoved$_reset keys');
      print('  Updated: $_yellow$totalUpdated$_reset metadata');

      if (dryRun) {
        print('\n$_yellow⚠️  DRY RUN: No files were modified$_reset');
      }
      print('$_blue════════════════════════════════════════════════════════$_reset');
    } catch (e, stackTrace) {
      _error('Fatal error: $e');
      if (verbose) {
        print(stackTrace);
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
    Set<String> sourceKeys,
    {
    required bool dryRun,
    required bool verbose,
  }) async {
    final fileName = file.path.split('/').last;
    print('$_blue📄 $fileName$_reset');

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
          // Update metadata for existing translations
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
      print('  $_green+ Added: ${added.length}$_reset');
      if (verbose) {
        for (final key in added) {
          print('    $_green+ $key$_reset');
        }
      }
    }

    if (removed.isNotEmpty) {
      print('  $_red- Removed: ${removed.length}$_reset');
      if (verbose) {
        for (final key in removed) {
          print('    $_red- $key$_reset');
        }
      }
    }

    if (updated.isNotEmpty && verbose) {
      print('  $_yellow~ Updated metadata: ${updated.length}$_reset');
    }

    if (added.isEmpty && removed.isEmpty && updated.isEmpty) {
      print('  $_green✓ Already in sync$_reset');
    }

    // Write file
    if (!dryRun && (added.isNotEmpty || removed.isNotEmpty || updated.isNotEmpty)) {
      _writeArb(file, sortedContent);
      print('  $_green✓ Saved$_reset');
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
    final translationKeys = content.keys.where((k) => !k.startsWith('@')).toList()
      ..sort();
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
      print('$prefix- $key');
    }
  }

  void _info(String message) => print('$_blue$message$_reset');
  void _warning(String message) => print('$_yellow⚠️  $message$_reset');
  void _error(String message) => print('$_red❌ $message$_reset');
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
