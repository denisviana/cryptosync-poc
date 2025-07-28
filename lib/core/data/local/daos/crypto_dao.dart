import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/crypto_tables.dart';

part 'crypto_dao.g.dart';

@DriftAccessor(tables: [Cryptos])
class CryptoDao extends DatabaseAccessor<AppDatabase> with _$CryptoDaoMixin {
  CryptoDao(AppDatabase db) : super(db);

  Stream<List<Crypto>> watchAllCryptos() => select(cryptos).watch();

  Future<void> upsertCrypto(CryptosCompanion crypto) =>
      into(cryptos).insertOnConflictUpdate(crypto);

  Future<List<Crypto>> getAllCryptos() async {
    final result = await select(cryptos).get();
    return result;
  }

  Future<void> clearAll() => delete(cryptos).go();
}
