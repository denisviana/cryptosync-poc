import 'package:injectable/injectable.dart';
import '../entities/crypto_ticker.dart';
import '../repositories/cryptos_repository.dart';

@injectable
class WatchTickersUseCase {
  final CryptosRepository _repo;
  WatchTickersUseCase(this._repo);

  Stream<List<CryptoTicker>> call() => _repo.watchAllTickers();
}