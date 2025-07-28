
import '../entities/crypto_ticker.dart';
import '../entities/interaction_entity.dart';

abstract class CryptosRepository {
  Stream<List<CryptoTicker>> watchAllTickers();

  Future<List<CryptoTicker>> fetchCachedTickers();

  Future<List<CryptoTicker>> fetchInitialTickers();

  Future<void> enqueueInteraction(Interaction interaction);

  Future<void> flushInteractions();

  Future<void> sendInteraction(Interaction interaction);
}
