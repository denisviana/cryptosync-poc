import 'package:drift/drift.dart';
import 'package:my_app/core/data/local/drift_database.dart';

class Cryptos extends Table {
  TextColumn get symbol => text()();

  TextColumn get name => text()();

  RealColumn get price => real()();

  RealColumn get changePercent => real()();

  IntColumn get lastUpdated => integer()();

  @override
  Set<Column> get primaryKey => {symbol};

}
