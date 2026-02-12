import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

class LocalCacheItems extends Table {
  TextColumn get key => text()();
  BlobColumn get data => blob()();
  IntColumn get expiry => integer().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

@LazySingleton()
@DriftDatabase(tables: [LocalCacheItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));

      final cachebase = await getTemporaryDirectory();
      sqlite3.tempDirectory = cachebase.path;

      return NativeDatabase.createInBackground(file);
    });
  }
}
