import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/domain/entities/crypto_ticker.dart';
import '../../../core/domain/entities/interaction_entity.dart';
import '../../../core/domain/use_cases/fetch_cached_tickers_usecase.dart';
import '../../../core/domain/use_cases/queue_interaction_usecase.dart';
import '../../../core/domain/use_cases/watch_tickers_usecase.dart';

class CryptoController extends GetxController {
  final WatchTickersUseCase _watchUseCase;
  final FetchCachedTickersUseCase _fetchUseCase;
  final QueueInteractionIterator _queueIterator;
  final Connectivity _connectivity;

  final tickers = <CryptoTicker>[].obs;
  final isOnline = true.obs;

  StreamSubscription<List<CryptoTicker>>? _tickerSub;
  StreamSubscription<List<ConnectivityResult>>? _connSub;

  CryptoController({
    required WatchTickersUseCase watchUseCase,
    required FetchCachedTickersUseCase fetchUseCase,
    required QueueInteractionIterator queueIterator,
    required Connectivity connectivity,
  })  : _watchUseCase = watchUseCase,
        _fetchUseCase = fetchUseCase,
        _queueIterator = queueIterator,
        _connectivity = connectivity;

  final RxSet<String> favorites = <String>{}.obs;

  void toggleFavorite(String symbol) {
    final willFav = !favorites.contains(symbol);
    if (willFav) {
      favorites.add(symbol);
      recordInteraction(Interaction(
        type: 'favorite',
        payload: {'symbol': symbol},
        timestamp: DateTime.now(),
      ));
    } else {
      favorites.remove(symbol);
      recordInteraction(Interaction(
        type: 'unfavorite',
        payload: {'symbol': symbol},
        timestamp: DateTime.now(),
      ));
    }
  }

  @override
  void onInit() {
    super.onInit();
    _connSub = _connectivity.onConnectivityChanged.listen((status) {
      isOnline.value = status.contains(
            ConnectivityResult.wifi,
          ) ||
          status.contains(
            ConnectivityResult.mobile,
          );
      if(isOnline.value){
        _flushQueuedInteractions();
      }
    });

    loadCache();

    _tickerSub = _watchUseCase().listen((list) {
      tickers.assignAll(list);
    });
  }

  Future<void> loadCache() async {
    final cached = await _fetchUseCase();
    tickers.assignAll(cached);
  }

  Future<void> _flushQueuedInteractions() async {
    try {
      await _queueIterator.flushQueue();
    } on Exception catch (e) {
      debugPrint('Erro ao enviar interações: $e');
    }
  }

  void recordInteraction(Interaction interaction) {
    if (isOnline.value) {
      _queueIterator.send(interaction);
    } else {
      _queueIterator.enqueue(interaction);
    }
  }

  @override
  void onClose() {
    _tickerSub?.cancel();
    _connSub?.cancel();
    super.onClose();
  }
}
