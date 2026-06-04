// lib/core/utils/app_routes.dart
import 'package:get/get.dart';

import '../../app/features/home/bindings/home_bindings.dart';
import '../../app/features/home/view/home_view.dart';
import '../../app/features/onboarding/bindings/onboard_binding.dart';
import '../../app/features/onboarding/view/onboard_view.dart';
import '../../app/features/result/binding/result_binding.dart';
import '../../app/features/result/view/result_view.dart';
import '../../ChatBoat/chatboatscreen/chatboatscreen.dart';
import '../../app/features/scan/bindings/scanner_binding.dart';
import '../../app/features/scan/view/scanner_view.dart';
import '../../app/features/splash/bindings/splash_binding.dart';
import '../../app/features/splash/view/splash_view.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String result = '/result';
  static const String chatBoat = '/chatboat';
  static const String favourites = '/favourites';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      binding: OnboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: scan,
      page: () => const ScanView(),
      binding: ScanBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: result,
      page: () => const ResultView(),
      binding: ResultBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: chatBoat,
      page: () => const ChatBoatScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
