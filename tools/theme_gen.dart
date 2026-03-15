// scripts/theme_gen.dart
// ─────────────────────────────────────────────────────────────
// Theme Code Generator (Token-centric, named-key format)
// ─────────────────────────────────────────────────────────────
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  ansiColorDisabled = false;
  final gen = ThemeGen();

  if (args.contains('--sync')) {
    gen.sync();
  } else if (args.contains('--expand')) {
    gen.expand();
  } else {
    gen.run(dryRun: args.contains('--dry-run'));
  }
}

// ─── ANSI colors ─────────────────────────────────────────────
bool ansiColorDisabled = false;
String _g(String s) => ansiColorDisabled ? s : '\x1B[32m$s\x1B[0m';
String _y(String s) => ansiColorDisabled ? s : '\x1B[33m$s\x1B[0m';
String _r(String s) => ansiColorDisabled ? s : '\x1B[31m$s\x1B[0m';
String _b(String s) => ansiColorDisabled ? s : '\x1B[34m$s\x1B[0m';
String _c(String s) => ansiColorDisabled ? s : '\x1B[36m$s\x1B[0m';
String _bd(String s) => ansiColorDisabled ? s : '\x1B[1m$s\x1B[0m';
// ─────────────────────────────────────────────────────────────

class ThemeGen {
  static const _configPath = 'lib/design/theme/colors/color_config.json';
  static const _tokensPath = 'lib/gen/theme/color_tokens.dart';
  static const _palettePath = 'lib/gen/theme/color_palettes.dart';
  static const _sourceTheme = 'light'; // used as template when expanding

  void expand() {
    _printHeader('EXPAND + GEN');

    final configFile = File(_configPath);
    final config = _loadConfig(configFile);
    final themeNames = _getThemeNames(config);
    final meta = config['meta'] as Map<String, dynamic>;
    final tokens = config['tokens'] as Map<String, dynamic>;

    final missingInArray = meta.keys
        .where((k) => !themeNames.contains(k))
        .toList();
    for (final t in missingInArray) {
      themeNames.add(t);
      _info('Added "$t" to themes array');
    }
    if (missingInArray.isNotEmpty) config['themes'] = themeNames;

    final missingInMeta = themeNames
        .where((name) => !meta.containsKey(name))
        .toList();
    if (missingInMeta.isNotEmpty) {
      final sourceIcon =
          ((meta[_sourceTheme] as Map<String, dynamic>?)?['icon'] as String?) ??
          'Icons.circle';
      print(
        _bd(
          _b(
            'Warning: themes missing in meta: ${_c(missingInMeta.join(', '))}',
          ),
        ),
      );
      print(_y('  Press Enter to use default value (shown in parentheses).'));
      print('');

      for (final themeName in missingInMeta) {
        print(_bd(_b('[meta.$themeName]')));
        final defaultLabel =
            '${themeName[0].toUpperCase()}${themeName.substring(1)}';
        print(_b('  label') + _y(' (Enter = "$defaultLabel"):'));
        stdout.write('    > ');
        final labelInput = stdin.readLineSync()?.trim() ?? '';
        final label = labelInput.isEmpty ? defaultLabel : labelInput;

        print(
          _b('  icon') + _y(' (Enter = copy from $_sourceTheme: $sourceIcon):'),
        );
        stdout.write('    > ');
        final iconInput = stdin.readLineSync()?.trim() ?? '';
        final icon = iconInput.isEmpty ? sourceIcon : iconInput;

        meta[themeName] = {'label': label, 'icon': icon};
        print('${_g('+')} meta["$themeName"] set: label="$label", icon=$icon');
        print('');
      }
    }

    final newThemes = themeNames
        .where((n) => _isThemeMissingInTokens(n, tokens))
        .toList();

    if (newThemes.isEmpty) {
      _writeConfig(configFile, config);
      print('${_g('OK')} No new tokens to expand.');
      print('');
      run();
      return;
    }

    print(_bd(_b('Expanding tokens for: ${_c(newThemes.join(', '))}')));
    print(_y('  Enter = copy from "$_sourceTheme", or type a new value'));
    print('');

    var totalAdded = 0;
    for (final groupEntry in tokens.entries) {
      final groupName = groupEntry.key;
      final fields = groupEntry.value as Map<String, dynamic>;

      for (final fieldEntry in fields.entries) {
        final fieldName = fieldEntry.key;
        final valueMap = Map<String, dynamic>.from(fieldEntry.value as Map);
        final sourceVal = valueMap[_sourceTheme] as String? ?? '';

        for (final newTheme in newThemes) {
          if (valueMap.containsKey(newTheme)) continue;

          print('  [$groupName.$fieldName]');
          print('  source ($_sourceTheme): ${_c(sourceVal)}');
          print('  $newTheme: ${_y("(Enter = copy, or type new color)")}');
          stdout.write('      > ');

          final input = stdin.readLineSync()?.trim() ?? '';
          final chosen = input.isEmpty ? sourceVal : input;
          valueMap[newTheme] = _isValidColorValue(chosen) ? chosen : sourceVal;
          totalAdded++;
          print('');
        }
        (tokens[groupName] as Map<String, dynamic>)[fieldName] = valueMap;
      }
    }

    _writeConfig(configFile, config);
    print('${_g('OK')} Saved $_configPath (+$totalAdded values)');
    print('');
    print(_b('> Generating code...'));
    print('');
    run();
  }

  bool _isThemeMissingInTokens(String themeName, Map<String, dynamic> tokens) {
    for (final group in tokens.values) {
      for (final valMap in (group as Map<String, dynamic>).values) {
        if (!(valMap as Map<String, dynamic>).containsKey(themeName))
          return true;
      }
    }
    return false;
  }

  void sync() {
    _printHeader('SYNC + GEN');

    final configFile = File(_configPath);
    final config = _loadConfig(configFile);
    final themeNames = _getThemeNames(config);
    final tokens = config['tokens'] as Map<String, dynamic>;
    var changes = 0;

    for (final groupEntry in tokens.entries) {
      final groupName = groupEntry.key;
      final fields = groupEntry.value as Map<String, dynamic>;

      for (final fieldEntry in fields.entries) {
        final fieldName = fieldEntry.key;
        final valueMap = Map<String, dynamic>.from(fieldEntry.value as Map);

        for (final themeName in themeNames) {
          if (valueMap.containsKey(themeName)) continue;

          print('');
          print(_bd(_b('[$groupName.$fieldName] -> theme: ${_c(themeName)}')));
          print(
            _y('   Enter color (0xAARRGGBB | Colors.xxx | AppColors.xxx):'),
          );
          stdout.write('   > ');

          final input = stdin.readLineSync()?.trim() ?? '';
          if (input.isEmpty || !_isValidColorValue(input)) {
            print(_r('   Invalid, try again.'));
            continue;
          }

          valueMap[themeName] = input;
          changes++;
        }
        (tokens[groupName] as Map<String, dynamic>)[fieldName] = valueMap;
      }
    }

    if (changes == 0) {
      print('${_g('+')} All tokens already complete.');
    } else {
      print('');
      _writeConfig(configFile, config);
      print('${_g('+')} Saved $_configPath (+$changes values)');
    }

    print('');
    print(_b('> Generating code...'));
    print('');
    run();
  }

  void run({bool dryRun = false}) {
    if (!dryRun) _printHeader('GEN');

    final config = _loadConfig(File(_configPath));
    final themeNames = _getThemeNames(config);
    final meta = config['meta'] as Map<String, dynamic>;
    final tokens = config['tokens'] as Map<String, dynamic>;

    _info('Themes: ${_c(themeNames.join(', '))}');
    _info('Groups: ${_c(tokens.keys.join(', '))}');
    print('');

    final errors = _validate(themeNames, meta, tokens);
    if (errors.isNotEmpty) {
      _err('Validation failed (${errors.length} error(s)):');
      for (final e in errors) print('  ${_r('* $e')}');
      print('');
      print(_y('Tip: Run `make theme-sync` to fill missing values.'));
      exit(1);
    }
    print('${_g('+')} Validation passed');
    print('');

    final schema = <String, List<String>>{
      for (final g in tokens.entries)
        g.key: (g.value as Map<String, dynamic>).keys.toList(),
    };

    final tokensCode = _genTokens(schema);
    final palettesCode = _genPalettes(themeNames, meta, tokens, schema);

    if (dryRun) {
      _printPreview('color_tokens.dart', tokensCode);
      _printPreview('color_palettes.dart', palettesCode);
    } else {
      final tokensFile = File(_tokensPath);
      if (!tokensFile.parent.existsSync()) {
        tokensFile.parent.createSync(recursive: true);
      }
      tokensFile.writeAsStringSync(tokensCode);
      print('${_g('+')} Generated: ${_c(_tokensPath)}');

      final paletteFile = File(_palettePath);
      if (!paletteFile.parent.existsSync()) {
        paletteFile.parent.createSync(recursive: true);
      }
      paletteFile.writeAsStringSync(palettesCode);
      print('${_g('+')} Generated: ${_c(_palettePath)}');
    }

    print('');
    _printSummary(themeNames.length, schema.length, dryRun);
  }

  List<String> _validate(
    List<String> themeNames,
    Map<String, dynamic> meta,
    Map<String, dynamic> tokens,
  ) {
    final errors = <String>[];
    for (final name in themeNames) {
      if (!meta.containsKey(name)) {
        errors.add('[meta] missing entry for theme "$name"');
      } else {
        final m = meta[name] as Map<String, dynamic>;
        if (!m.containsKey('label')) errors.add('[meta.$name] missing "label"');
        if (!m.containsKey('icon')) errors.add('[meta.$name] missing "icon"');
      }
    }

    for (final groupEntry in tokens.entries) {
      final gName = groupEntry.key;
      final fields = groupEntry.value as Map<String, dynamic>;
      for (final fieldEntry in fields.entries) {
        final fName = fieldEntry.key;
        final valMap = fieldEntry.value as Map<String, dynamic>;
        for (final themeName in themeNames) {
          if (!valMap.containsKey(themeName)) {
            errors.add('[$gName.$fName] missing value for theme "$themeName"');
          } else {
            final val = valMap[themeName] as String;
            if (!_isValidColorValue(val)) {
              errors.add('[$gName.$fName.$themeName] invalid "$val"');
            }
          }
        }
        for (final key in valMap.keys) {
          if (!themeNames.contains(key)) {
            errors.add('[$gName.$fName] unknown theme key "$key"');
          }
        }
      }
    }
    return errors;
  }

  String _genTokens(Map<String, List<String>> schema) {
    final buf = StringBuffer();
    buf.write(_genHeader('lib/gen/theme/color_tokens.dart'));
    buf.writeln("import 'package:flutter/material.dart';");
    buf.writeln('');
    buf.writeln('extension AppColorTokensX on BuildContext {');
    buf.writeln(
      '  AppColorTokens get colors => Theme.of(this).extension<AppColorTokens>()!;',
    );
    buf.writeln('}');
    buf.writeln('');

    for (final group in schema.entries) {
      buf.write(_genGroupClass(_cls(group.key), group.value));
    }

    buf.writeln(
      'class AppColorTokens extends ThemeExtension<AppColorTokens> {',
    );
    for (final g in schema.keys) buf.writeln('  final ${_cls(g)} $g;');
    buf.writeln('');
    buf.writeln('  const AppColorTokens({');
    for (final g in schema.keys) buf.writeln('    required this.$g,');
    buf.writeln('  });');
    buf.writeln('');
    buf.writeln('  @override');
    buf.writeln('  AppColorTokens copyWith({');
    for (final g in schema.keys) buf.writeln('    ${_cls(g)}? $g,');
    buf.writeln('  }) => AppColorTokens(');
    for (final g in schema.keys) buf.writeln('    $g: $g ?? this.$g,');
    buf.writeln('  );');
    buf.writeln('');
    buf.writeln('  @override');
    buf.writeln(
      '  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {',
    );
    buf.writeln('    if (other is! AppColorTokens) return this;');
    buf.writeln('    return AppColorTokens(');
    for (final g in schema.keys)
      buf.writeln('      $g: ${_cls(g)}.lerp($g, other.$g, t),');
    buf.writeln('    );');
    buf.writeln('  }');
    buf.writeln('}');
    return buf.toString();
  }

  String _genGroupClass(String className, List<String> fields) {
    final buf = StringBuffer();
    buf.writeln('class $className {');
    for (final f in fields) buf.writeln('  final Color $f;');
    buf.writeln('');
    buf.writeln('  const $className({');
    for (final f in fields) buf.writeln('    required this.$f,');
    buf.writeln('  });');
    buf.writeln('');
    buf.writeln('  $className copyWith({');
    for (final f in fields) buf.writeln('    Color? $f,');
    buf.writeln('  }) => $className(');
    for (final f in fields) buf.writeln('    $f: $f ?? this.$f,');
    buf.writeln('  );');
    buf.writeln('');
    buf.writeln(
      '  static $className lerp($className a, $className b, double t) => $className(',
    );
    for (final f in fields) buf.writeln('    $f: Color.lerp(a.$f, b.$f, t)!,');
    buf.writeln('  );');
    buf.writeln('}');
    buf.writeln('');
    return buf.toString();
  }

  String _genPalettes(
    List<String> themeNames,
    Map<String, dynamic> meta,
    Map<String, dynamic> tokens,
    Map<String, List<String>> schema,
  ) {
    final buf = StringBuffer();
    buf.write(_genHeader('lib/gen/theme/color_palettes.dart'));
    buf.writeln("import 'package:flutter/material.dart';");
    buf.writeln("import 'color_tokens.dart';");
    if (_needsAppColorsImport(tokens))
      buf.writeln("import '../app_colors.dart';");
    buf.writeln('');
    buf.writeln('enum AppColorTheme { ${themeNames.join(', ')} }');
    buf.writeln('');
    buf.writeln('class AppColorPalettes {');
    buf.writeln('  AppColorPalettes._();');
    buf.writeln('');
    buf.writeln(
      '  static AppColorTokens of(AppColorTheme theme) => switch (theme) {',
    );
    for (final name in themeNames)
      buf.writeln('    AppColorTheme.$name => $name,');
    buf.writeln('  };');
    buf.writeln('');
    buf.writeln('  static const Map<AppColorTheme, String> labels = {');
    for (final name in themeNames) {
      final label = (meta[name] as Map<String, dynamic>)['label'] as String;
      buf.writeln("    AppColorTheme.$name: '$label',");
    }
    buf.writeln('  };');
    buf.writeln('');
    buf.writeln('  static const Map<AppColorTheme, IconData> icons = {');
    for (final name in themeNames) {
      final icon = (meta[name] as Map<String, dynamic>)['icon'] as String;
      buf.writeln('    AppColorTheme.$name: $icon,');
    }
    buf.writeln('  };');
    buf.writeln('');
    buf.writeln(
      '  static List<AppColorTheme> get all => AppColorTheme.values;',
    );
    buf.writeln('');

    for (final name in themeNames) {
      buf.writeln('  // --- ${name.toUpperCase()} ---');
      buf.writeln('  static const AppColorTokens $name = AppColorTokens(');
      for (final group in schema.entries) {
        final gKey = group.key;
        final fields = tokens[gKey] as Map<String, dynamic>;
        buf.writeln('    $gKey: ${_cls(gKey)}(');
        for (final field in group.value) {
          final valMap = fields[field] as Map<String, dynamic>;
          final raw = valMap[name] as String;
          buf.writeln('      $field: ${_expr(raw)},');
        }
        buf.writeln('    ),');
      }
      buf.writeln('  );');
      buf.writeln('');
    }
    buf.writeln('}');
    return buf.toString();
  }

  Map<String, dynamic> _loadConfig(File file) {
    if (!file.existsSync()) {
      _err('Config not found: $_configPath');
      exit(1);
    }
    try {
      return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    } catch (e) {
      _err('Invalid JSON: $e');
      exit(1);
    }
  }

  void _writeConfig(File file, Map<String, dynamic> config) =>
      file.writeAsStringSync(
        '${const JsonEncoder.withIndent('    ').convert(config)}\n',
      );

  List<String> _getThemeNames(Map<String, dynamic> config) {
    if (!config.containsKey('themes') || config['themes'] is! List) {
      _err('Missing "themes" array in config.');
      exit(1);
    }
    return List<String>.from(config['themes'] as List);
  }

  bool _isValidColorValue(String val) => _isHex(val) || _isDartRef(val);
  bool _isHex(String val) => RegExp(r'^0x[0-9A-Fa-f]{8}$').hasMatch(val);
  bool _isDartRef(String val) =>
      RegExp(r'^[A-Z][A-Za-z]*\.[a-zA-Z][a-zA-Z0-9]*$').hasMatch(val);
  String _expr(String raw) => _isHex(raw) ? 'Color($raw)' : raw;

  bool _needsAppColorsImport(Map<String, dynamic> tokens) {
    for (final group in tokens.values) {
      for (final valMap in (group as Map<String, dynamic>).values) {
        for (final v in (valMap as Map<String, dynamic>).values) {
          if ((v as String).startsWith('AppColors')) return true;
        }
      }
    }
    return false;
  }

  String _cls(String key) =>
      'App${key[0].toUpperCase()}${key.substring(1)}Colors';

  String _genHeader(String path) =>
      '// $path\n'
      '// AUTO-GENERATED — DO NOT EDIT MANUALLY\n'
      '// Edit: lib/design/theme/colors/color_config.json\n'
      '// Regen: make theme-gen | make theme-sync\n'
      '// Generated: ${DateTime.now().toLocal()}\n\n';

  void _printPreview(String name, String content) {
    print(_y('--- DRY RUN: $name ---'));
    print(content);
  }

  void _printHeader(String mode) {
    final line = '=' * 56;
    print(_b(line));
    print(_bd(_b('  Theme Code Generator -- $mode')));
    print(_b(line));
    print('');
  }

  void _printSummary(int themeCount, int groupCount, bool dryRun) {
    final line = '=' * 56;
    print(_b(line));
    print(_bd(_g('  Done!')));
    print(_g('  * $themeCount theme(s)'));
    print(_g('  * $groupCount group class(es) in color_tokens.dart'));
    if (dryRun) print(_y('  DRY RUN -- no files written'));
    print(_b(line));
  }

  void _info(String s) => print(_b('[i] $s'));
  void _err(String s) => print(_r('[!] $s'));
}
