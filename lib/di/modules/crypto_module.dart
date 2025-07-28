import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/data/local/daos/crypto_dao.dart';
import '../../core/data/local/drift_database.dart';
import '../../core/data/network/crypto_api.dart';

@module
abstract class CryptoModule {
  @singleton
  WebSocketChannel get webSocketChannel => WebSocketChannel.connect(
        Uri.parse('wss://stream.binance.com:9443/ws/!miniTicker@arr'),
      );

  @singleton
  CryptoApi provideCryptoApi(WebSocketChannel channel) => CryptoApi(channel);

  @singleton
  AppDatabase provideAppDatabase() => AppDatabase();

  @singleton
  CryptoDao provideCryptoDao(AppDatabase db) => CryptoDao(db);

  @singleton
  Connectivity provideConnectivity() => Connectivity();
}
