import 'package:get/get.dart';
import 'package:my_app/app/pages/home/crypto_bindings.dart';
import 'package:my_app/app/pages/home/crypto_page.dart';

abstract class Routes {
  static String initial = '/';
}

mixin AppRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.initial,
      page: () => const CryptoPage(),
      binding: CryptoBindinds(),
    ),
  ];
}
