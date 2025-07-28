import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../domain/entities/crypto_ticker.dart';
import '../../domain/repositories/cryptos_repository.dart';
import '../local/drift_database.dart';
import '../network/crypto_api.dart';

@Injectable(as: CryptosRepository)
class CryptoRepositoryImpl implements CryptosRepository {
  final CryptoApi _api;
  final AppDatabase _db;

  CryptoRepositoryImpl(this._api, this._db);

  @override
  Stream<List<CryptoTicker>> watchAllTickers() {
    // 1) inscreve no WS
    _api.subscribeToTickers().listen((ticker) {
      // 2) a cada atualização, grava no DB
      _db.cryptoDao.upsertCrypto(
        CryptosCompanion.insert(
          symbol: ticker.symbol,
          name: ticker.name,
          price: ticker.price,
          changePercent: ticker.percentChange,
          lastUpdated: ticker.lastUpdated.millisecondsSinceEpoch,
        ),
      );
    });
    // 3) retorna o cache reativo
    return _db.cryptoDao.watchAllCryptos().map((rows) => rows
        .map((r) => CryptoTicker(
              symbol: r.symbol,
              name: r.name,
              price: r.price,
              percentChange: r.changePercent,
              lastUpdated: DateTime.fromMillisecondsSinceEpoch(r.lastUpdated),
            ))
        .toList());
  }

  @override
  Future<List<CryptoTicker>> fetchCachedTickers() async {
    final rows = await _db.cryptoDao.getAllCryptos();
    return rows
        .map((r) => CryptoTicker(
              symbol: r.symbol,
              name: r.name,
              price: r.price,
              percentChange: r.changePercent,
              lastUpdated: DateTime.fromMillisecondsSinceEpoch(r.lastUpdated),
            ))
        .toList();
  }

  @override
  Future<List<CryptoTicker>> fetchInitialTickers() =>
      _api.subscribeToTickers().take(10).toList();
}
