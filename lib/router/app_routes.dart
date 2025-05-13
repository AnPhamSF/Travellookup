import 'package:travellookup/pages/splash.dart';
import 'package:travellookup/view/forgot_password/forgot.dart';
import 'package:travellookup/view/login/login.dart';
import 'package:travellookup/view/reset_password/reset_password.dart';
import 'package:travellookup/view/signup/signup.dart';
import 'package:get/get.dart';

import '../data/api/api.dart';
import '../view/forgot_password/controller/forgot_password_controller.dart';
import '../view/signup/controller/signup_controller.dart';

class AppRoutes {
  static String login = '/login';

  static String signup = '/signup';

  static String reset = '/reset';

  static String forgot = '/forgot';

  static String onBoarding = '/onBoarding';

  static List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const Login(),
    ),
    GetPage(
      name: signup,
      page: () => const SignUp(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ApiClient());
        Get.lazyPut(() => SignUpController(Get.find()));
      }),
    ),
    GetPage(
      name: forgot,
      page: () => const ForgotPassword(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ApiClient());
        Get.lazyPut(() => ForgotPasswordController(Get.find()));
      }),
    ),
    GetPage(
      name: reset,
      page: () => const ResetPassword(),
    ),
    GetPage(
      name: onBoarding,
      page: () => const SplashPage(),
    )
  ];
}
