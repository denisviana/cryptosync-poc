import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/crypto_ticker.dart';

class CryptoApi {
  final WebSocketChannel _channel;
  StreamController<CryptoTicker>? _controller;

  CryptoApi(this._channel);

  /// Inscreve no stream de mini-tickers e retorna um Stream de [CryptoTicker]
  Stream<CryptoTicker> subscribeToTickers() {
    _controller ??= StreamController<CryptoTicker>.broadcast(
      onListen: _listenSocket,
      onCancel: () => _controller?.close(),
    );
    return _controller!.stream;
  }

  void _listenSocket() {
    _channel.stream.listen(
      (raw) {
        try {
          final data = json.decode(raw) as List<dynamic>;
          final now = DateTime.now();

          for (final item in data.cast<Map<String, dynamic>>()) {
            final symbol = item['s']?.toString().replaceAll('USDT', '') ?? '';
            final price = double.tryParse(item['c']?.toString() ?? '') ?? 0;
            final openPrice =
                double.tryParse(item['o']?.toString() ?? '') ?? price;
            final percentChange =
                openPrice != 0 ? ((price - openPrice) / openPrice) * 100 : 0;

            _controller?.add(
              CryptoTicker(
                symbol: symbol,
                name: symbol,
                // pode mapear para nome completo se desejar
                price: price,
                percentChange: percentChange.toDouble(),
                lastUpdated: now,
              ),
            );
          }
        } on FormatException catch (e) {
          debugPrint('JSON parse error in CryptoApi: $e');
        } on Exception catch (e, _) {
          debugPrint('Unexpected error in CryptoApi: $e\n$_');
        }
      },
      onError: (e) => debugPrint('WebSocket error in CryptoApi: $e'),
      onDone: () => debugPrint('WebSocket connection closed'),
    );
  }
}
