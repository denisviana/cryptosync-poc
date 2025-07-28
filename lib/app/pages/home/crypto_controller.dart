import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../../core/domain/entities/crypto_ticker.dart';
import '../../../core/domain/use_cases/fetch_cached_tickers_usecase.dart';
import '../../../core/domain/use_cases/watch_tickers_usecase.dart';

/// Controller (ViewModel) usando GetX para gerenciar estado da UI
class CryptoController extends GetxController {
  final WatchTickersUseCase _watchUseCase;
  final FetchCachedTickersUseCase _fetchUseCase;
  final Connectivity _connectivity;

  // Observables para UI
  final tickers = <CryptoTicker>[].obs;
  final isOnline = true.obs;

  StreamSubscription<List<CryptoTicker>>? _tickerSub;
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  CryptoController({
    required WatchTickersUseCase watchUseCase,
    required FetchCachedTickersUseCase fetchUseCase,
    required Connectivity connectivity,
  })  : _watchUseCase = watchUseCase,
        _fetchUseCase = fetchUseCase,
        _connectivity = connectivity;

  @override
  void onInit() {
    super.onInit();

    // Observa conexão
    _connSub = _connectivity.onConnectivityChanged.listen((status) {
      isOnline.value = status.contains(
            ConnectivityResult.wifi,
          ) ||
          status.contains(
            ConnectivityResult.mobile,
          );
    });

    // Carrega cache inicial
    loadCache();

    // Inicia WebSocket + sync
    _tickerSub = _watchUseCase().listen((list) {
      tickers.assignAll(list);
    });
  }

  /// Carrega tickers armazenados no DB
  Future<void> loadCache() async {
    final cached = await _fetchUseCase();
    tickers.assignAll(cached);
  }

  @override
  void onClose() {
    _tickerSub?.cancel();
    _connSub?.cancel();
    super.onClose();
  }
}
