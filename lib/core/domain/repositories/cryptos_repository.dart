
import '../entities/crypto_ticker.dart';

abstract class CryptosRepository {
  Stream<List<CryptoTicker>> watchAllTickers();

  Future<List<CryptoTicker>> fetchCachedTickers();

  Future<List<CryptoTicker>> fetchInitialTickers();
}
