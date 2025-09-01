import 'dart:io';

void main() {
  // Đọc file vi_VN.dart làm base vì nó chứa tất cả keys
  final viFile = File('../lib/core/lang/vi/vi_VN.dart');
  final content = viFile.readAsStringSync();

  // Extract các keys từ Map
  final keys = extractKeys(content);

  // Generate code cho locale_keys.dart
  final localeKeysContent = generateLocaleKeysContent(keys);

  // Ghi ra file
  final localeKeysFile = File('../lib/core/lang/locale_keys.dart');
  localeKeysFile.writeAsStringSync(localeKeysContent);

  print('Generated locale_keys.dart successfully!');
}

List<String> extractKeys(String content) {
  final keys = <String>[];
  final regExp = RegExp(r"'([^']+)':\s*'[^']*'");
  
  for (final match in regExp.allMatches(content)) {
    final key = match.group(1);
    if (key != null) {
      keys.add(key);
    }
  }

  return keys;
}

String generateLocaleKeysContent(List<String> keys) {
  final buffer = StringBuffer();
  buffer.writeln('class LocaleKeys {');

  // Group keys by prefix
  final groups = <String, List<String>>{};
  
  for (final key in keys) {
    final parts = key.split('_');
    final prefix = parts[0];
    groups.putIfAbsent(prefix, () => []).add(key);
  }

  // Generate constants grouped by prefix
  groups.forEach((prefix, groupKeys) {
    buffer.writeln('\n  // === ${prefix.toUpperCase()} ===');
    for (final key in groupKeys) {
      buffer.writeln("  static const $key = '$key';");
    }
  });

  buffer.writeln('}');
  return buffer.toString();
}