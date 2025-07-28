import 'package:injectable/injectable.dart';
import '../entities/crypto_ticker.dart';
import '../repositories/cryptos_repository.dart';

@injectable
class FetchCachedTickersUseCase {
  final CryptosRepository _repo;
  FetchCachedTickersUseCase(this._repo);

  Future<List<CryptoTicker>> call() => _repo.fetchCachedTickers();
}