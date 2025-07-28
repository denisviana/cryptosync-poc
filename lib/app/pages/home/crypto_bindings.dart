import 'package:get/get.dart';
import 'package:my_app/di/di.dart';

import 'crypto_controller.dart';

class CryptoBindinds extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CryptoController>(
      () => CryptoController(
        watchUseCase: getIt(),
        fetchUseCase: getIt(),
        connectivity: getIt(),
        queueIterator: getIt(),
      ),
    );
  }
}
