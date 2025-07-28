import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/app/pages/home/crypto_controller.dart';

class CryptoPage extends GetView<CryptoController> {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('CryptoSync'),
          actions: [
            Obx(() {
              final online = controller.isOnline.value;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  online ? Icons.wifi : Icons.wifi_off,
                  color: online ? Colors.green : Colors.red,
                  size: 20,
                ),
              );
            }),
          ],
        ),
        body: Obx(() {
          final tickers = controller.tickers;
          if (tickers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tickers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final t = tickers[index];
              final isPositive = t.percentChange >= 0;
              final priceColor = isPositive ? Colors.green : Colors.red;
              final arrow = isPositive ? '↑' : '↓';
              final favorites = controller.favorites; // RxSet<String>
              final isFav = favorites.contains(t.symbol);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          t.symbol,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${t.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$arrow ${t.percentChange.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: priceColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: isFav ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () => controller.toggleFavorite(t.symbol),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      );
}
