import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:my_app/core/data/local/tables/crypto_tables.dart';
import 'package:my_app/core/data/local/tables/interactions_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/crypto_dao.dart';
import 'daos/interactions_dao.dart';

part 'drift_database.g.dart';

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app.db'));
      return NativeDatabase(file)..logStatements = true;
    });

@DriftDatabase(
    tables: [Cryptos, Interactions], daos: [CryptoDao, InteractionDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      await migrator.createAll();
    },
    onCreate: (migrator) async {
      await migrator.createAll();
    },
  );
}


