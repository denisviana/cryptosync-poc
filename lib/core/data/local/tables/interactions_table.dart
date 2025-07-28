import 'package:drift/drift.dart';

class Interactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get type => text()();

  TextColumn get payload => text()();

  IntColumn get timestamp => integer()();
}
