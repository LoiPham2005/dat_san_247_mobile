// =============================================================================
// 🌉  Route Generator Tool (v6 - Clean & Typed)
// =============================================================================
// Triết lý:
// 1. Chỉ dùng RouteNames để giữ Path Constant (bắt buộc cho Annotation).
// 2. Việc truyền tham số sẽ dùng hoàn toàn qua Typed Route Class (IntroRoute(...)).
// =============================================================================

import 'dart:io';

const _featuresDir = 'lib/features';
const _routesFile = 'lib/routes/config/app_routes.dart';
const _routerFile = 'lib/routes/config/app_router.dart';
const _routeNamesFile = 'lib/routes/constants/route_names.dart';

// ─── ANSI Colors ─────────────────────────────────────────────────────────────
const _reset = '\x1B[0m';
const _green = '\x1B[32m';
const _yellow = '\x1B[33m';
const _red = '\x1B[31m';
const _cyan = '\x1B[36m';
const _bold = '\x1B[1m';

void main(List<String> args) {
  final params = _parseArgs(args);

  if (params['help'] == 'true') {
    _printHelp();
    return;
  }

  if (params['list'] == 'true') {
    _listRoutes();
    return;
  }

  if (params['scan'] == 'true') {
    _scanAndGenerate();
    return;
  }

  _error('Vui lòng dùng --scan để tự động quét.');
}

// =============================================================================
// SCAN & GENERATE
// =============================================================================
void _scanAndGenerate() {
  print('\n$_bold$_cyan🌉  Quét Routes (Tập trung Typed Routing)...$_reset\n');

  final featuresDir = Directory(_featuresDir);
  if (!featuresDir.existsSync()) {
    _error('Thư mục $_featuresDir không tồn tại.');
    return;
  }

  final files = featuresDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  int foundCount = 0;
  int addedCount = 0;

  for (final file in files) {
    final content = file.readAsStringSync();
    final markerRegex = RegExp(
      r'//\s*@route:\s*([^\s\[]+)(?:\s*\[([^\]]+)\])?|@route',
    );
    final match = markerRegex.firstMatch(content);

    if (match != null) {
      foundCount++;
      final classRegex = RegExp(r'class\s+(\w+)\s+extends');
      final classMatches = classRegex
          .allMatches(content)
          .where((m) => m.start > match.start);
      if (classMatches.isEmpty) continue;

      final classMatch = classMatches.first;
      final className = classMatch.group(1)!;

      final props = <Map<String, String>>[];
      final propRegex = RegExp(
        r'^\s*final\s+([\w<>?]+)\s+(\w+);',
        multiLine: true,
      );
      final propMatches = propRegex.allMatches(content);
      final buildIndex = content.indexOf('Widget build');

      for (final m in propMatches) {
        if (m.start > classMatch.start &&
            (buildIndex == -1 || m.start < buildIndex)) {
          if (m.group(2) == 'key') continue;
          props.add({'type': m.group(1)!, 'name': m.group(2)!});
        }
      }

      final pageName = className;
      final routeClassName = className.endsWith('Page')
          ? className.replaceFirst('Page', 'Route')
          : '${className}Route';

      String? path = (match.groupCount >= 1 && match.group(1) != null)
          ? match.group(1)
          : null;
      
      if (path == null) {
        final kebab = className.replaceAll('Page', '').replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (m) => '${m.group(1)}-${m.group(2)}'
        ).toLowerCase();
        path = '/$kebab';
      }

      String group = (match.groupCount >= 2 && match.group(2) != null)
          ? match.group(2)!
          : 'Main App';
      
      // Auto-detect group from path
      if (file.path.contains('lib/features/venue_staff/')) group = 'Staff';
      else if (file.path.contains('lib/features/owner/')) group = 'Owner';

      String cleanPath = file.path.replaceAll('\\', '/');
      if (cleanPath.contains('/lib/')) {
        cleanPath = cleanPath.substring(cleanPath.lastIndexOf('/lib/') + 5);
      } else if (cleanPath.startsWith('lib/')) {
        cleanPath = cleanPath.substring(4);
      }

      final added = _generate(
        name: routeClassName,
        path: path,
        page: pageName,
        importPath: cleanPath,
        group: group,
        properties: props,
        isQuiet: true,
      );
      if (added) addedCount++;
    }
  }

  print('─' * 50);
  print(
    '📊 Kết quả: Hoàn tất quét $_bold$foundCount$_reset file, thêm/cập nhật $_green$_bold$addedCount$_reset routes.',
  );
}

// =============================================================================
// GENERATE CORE
// =============================================================================
bool _generate({
  required String name,
  required String path,
  required String page,
  required String importPath,
  required String group,
  required List<Map<String, String>> properties,
  bool isQuiet = false,
}) {
  final routesFile = File(_routesFile);
  final routerFile = File(_routerFile);
  final routeNamesFile = File(_routeNamesFile);

  final constantName =
      name.replaceFirst('Route', '').substring(0, 1).toLowerCase() +
      name.replaceFirst('Route', '').substring(1);

  // 1. LUÔN ĐẢM BẢO IMPORT (Ngay cả khi route đã tồn tại)
  final routerContent = routerFile.readAsStringSync();
  final newRouter = _injectImport(
    content: routerContent,
    importLine: "import '../../$importPath';",
  );
  routerFile.writeAsStringSync(newRouter);

  // 2. LUÔN ĐẢM BẢO CONSTANT
  final currentRouteNames = routeNamesFile.readAsStringSync();
  if (!currentRouteNames.contains('static const String $constantName = ')) {
    final newRouteNames = _injectConstant(
      content: currentRouteNames,
      name: constantName,
      path: path,
      group: group,
    );
    routeNamesFile.writeAsStringSync(newRouteNames);
  }

  // 3. CHỈ THÊM ROUTE BLOCK NẾU CHƯA CÓ
  final currentRoutes = routesFile.readAsStringSync();
  if (currentRoutes.contains('class $name extends GoRouteData')) {
    if (!isQuiet)
      _warn('⚠️  Route "$name" đã có block definition. Bỏ qua bước này.');
    return true; // Vẫn tính là thành công để báo kết quả
  }

  if (!isQuiet) {
    print('  $_green●$_reset Adding Route Block: $_bold$name$_reset');
  }

  final routeBlock = _buildRouteBlock(
    name: name,
    constantName: constantName,
    page: page,
    properties: properties,
  );
  final newRoutes = _injectRoute(
    content: currentRoutes,
    routeBlock: routeBlock,
    group: group,
  );
  routesFile.writeAsStringSync(newRoutes);

  return true;
}

// =============================================================================
// BUILDERS & INJECTORS
// =============================================================================
String _buildRouteBlock({
  required String name,
  required String constantName,
  required String page,
  required List<Map<String, String>> properties,
}) {
  final fieldsStr = properties
      .map((e) => '  final ${e['type']} ${e['name']};')
      .join('\n');

  final constructorParams = properties
      .map((k) {
        String def = '""';
        if (k['type'] == 'bool') def = 'false';
        else if (k['type'] == 'int') def = '0';
        else if (k['type'] == 'double') def = '0.0';
        else if (k['type']!.contains('?')) def = 'null';
        else if (!['String', 'bool', 'int', 'double'].contains(k['type'])) {
           // Complex types should be required if not nullable, or have a factory default
           // For simple tool, we'll use 'required' or just omit default
           return 'required this.${k['name']}';
        }
        return 'this.${k['name']} = $def';
      })
      .join(', ');
  
  final constructor = properties.isEmpty
      ? '  const $name();'
      : '  const $name({$constructorParams});';

  final passParams = properties
      .map((k) => '${k['name']}: ${k['name']}')
      .join(', ');
  final buildBody = properties.isEmpty ? 'const $page()' : '$page($passParams)';

  return '''
@TypedGoRoute<$name>(path: RouteNames.$constantName)
class $name extends GoRouteData with \$$name {
${fieldsStr.isNotEmpty ? '$fieldsStr\n' : ''}$constructor

  @override
  Widget build(BuildContext context, GoRouterState state) => $buildBody;
}
''';
}

String _injectConstant({
  required String content,
  required String name,
  required String path,
  required String group,
}) {
  final groupMarker = '// $group';
  int index = content.indexOf(groupMarker);
  
  // If group not found, look for similar markers or create one
  if (index == -1 && group == 'Staff') {
    index = content.indexOf('// Venue Staff'); // Check existing name
    if (index == -1) index = content.indexOf('// Owner'); // fallback to near group
  }
  
  if (index == -1) index = content.indexOf('// Main App');

  if (index == -1) {
    final int lastBrace = content.lastIndexOf('}');
    if (lastBrace == -1) return content;
    return '${content.substring(0, lastBrace).trimRight()}\n  // $group\n  static const String $name = \'$path\';\n}';
  }

  // Find the end of the current group (next marker or empty line with spacing)
  final lineEnd = content.indexOf('\n', index);
  // Find next static const or next group or end of class
  final nextGroup = content.indexOf('//', lineEnd + 1);
  final endOfClass = content.indexOf('}', lineEnd + 1);
  
  int insertAt = endOfClass;
  if (nextGroup != -1 && nextGroup < endOfClass) {
    insertAt = nextGroup;
  }

  return '${content.substring(0, insertAt).trimRight()}\n  static const String $name = \'$path\';\n${content.substring(insertAt).trimLeft()}';
}

String _injectRoute({
  required String content,
  required String routeBlock,
  required String group,
}) {
  final groupComment = '// ─── $group ';
  final groupIndex = content.indexOf(groupComment);

  if (groupIndex != -1) {
    final nextGroupIndex = content.indexOf(
      '\n// ───',
      groupIndex + groupComment.length,
    );
    final insertAt = nextGroupIndex != -1 ? nextGroupIndex : content.length;
    return '${content.substring(0, insertAt).trimRight()}\n\n$routeBlock\n${content.substring(insertAt).trimLeft()}';
  }
  return '${content.trim()}\n\n$routeBlock\n';
}

String _injectImport({required String content, required String importLine}) {
  if (content.contains(importLine)) return content;
  final lines = content.split('\n');
  final int lastImport = lines.lastIndexWhere(
    (l) => l.trim().startsWith('import '),
  );
  if (lastImport == -1) return '$importLine\n$content';
  lines.insert(lastImport + 1, importLine);
  return lines.join('\n');
}

// =============================================================================
// HELPERS
// =============================================================================
Map<String, String> _parseArgs(List<String> args) {
  final map = <String, String>{};
  for (int i = 0; i < args.length; i++) {
    if (args[i].startsWith('--')) {
      final key = args[i].substring(2);
      if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
        map[key] = args[i + 1];
        i++;
      } else
        map[key] = 'true';
    }
  }
  return map;
}

void _listRoutes() {
  final content = File(_routesFile).readAsStringSync();
  final regex = RegExp(
    r"@TypedGoRoute<(\w+)>\(path: (?:RouteNames\.(\w+)|'([^']+)')\)",
  );
  print('\n$_bold$_cyan🛣️  Danh sách Routes:$_reset');
  for (final m in regex.allMatches(content)) {
    final name = m.group(1);
    final path = m.group(2) != null ? 'RouteNames.${m.group(2)}' : m.group(3);
    print('  $_green●$_reset $_bold$name$_reset → $path');
  }
}

void _printHelp() {
  print('''
$_bold$_cyan🛣️  Route Generator v6 (Typed Only)$_reset
- Chỉ sinh Constant cho RouteNames.
- Tự động sinh constructor với default values an toàn.
''');
}

void _error(String msg) => print('$_red❌ ERROR: $msg$_reset');
void _warn(String msg) => print('$_yellow$msg$_reset');
