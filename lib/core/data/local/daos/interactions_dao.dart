import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/interactions_table.dart';

part 'interactions_dao.g.dart';

@DriftAccessor(tables: [Interactions])
class InteractionDao extends DatabaseAccessor<AppDatabase>
    with _$InteractionDaoMixin {
  InteractionDao(AppDatabase db) : super(db);

  Future<int> insertInteraction(InteractionsCompanion entry) =>
      into(interactions).insert(entry);

  Future<List<Interaction>> getAllInteractions() =>
      select(interactions).get();

  Future<void> deleteInteractionById(int id) =>
      (delete(interactions)..where((tbl) => tbl.id.equals(id))).go();
}
