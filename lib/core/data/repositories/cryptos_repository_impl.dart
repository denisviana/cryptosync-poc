import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/crypto_ticker.dart';
import '../../domain/entities/interaction_entity.dart';
import '../../domain/repositories/cryptos_repository.dart';
import '../local/drift_database.dart' hide Interaction;
import '../network/crypto_api.dart';

@Injectable(as: CryptosRepository)
class CryptoRepositoryImpl implements CryptosRepository {
  final CryptoApi _api;
  final AppDatabase _db;
  final Dio _dio;

  CryptoRepositoryImpl(this._api, this._db, this._dio);

  @override
  Stream<List<CryptoTicker>> watchAllTickers() {
    _api.subscribeToTickers().listen((ticker) {
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

  @override
  Future<void> enqueueInteraction(Interaction interaction) async {
    final entry = InteractionsCompanion.insert(
      type: interaction.type,
      payload: jsonEncode(interaction.payload),
      timestamp: interaction.timestamp.millisecondsSinceEpoch,
    );
    await _db.interactionDao.insertInteraction(entry);
  }

  @override
  Future<void> flushInteractions() async {
    final rows = await _db.interactionDao.getAllInteractions();
    for (final row in rows) {
      final interaction = Interaction(
        id: row.id,
        type: row.type,
        payload: jsonDecode(row.payload),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
      );
      await sendInteraction(interaction);
      await _db.interactionDao.deleteInteractionById(row.id);
    }
  }

  @override
  Future<void> sendInteraction(Interaction interaction) async {
    final data = {
      'type': interaction.type,
      'payload': interaction.payload,
      'timestamp': interaction.timestamp.toIso8601String(),
    };

    log('Sending interaction: $data');
  }
}
