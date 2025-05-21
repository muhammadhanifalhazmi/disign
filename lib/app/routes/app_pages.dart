import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/certificate/bindings/certificate_binding.dart';
import '../modules/certificate/views/certificate_view.dart';
import '../modules/list_device/bindings/list_device_binding.dart';
import '../modules/list_device/views/list_device_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_device/bindings/register_device_binding.dart';
import '../modules/register_device/views/register_device_view.dart';
import '../modules/revoke/bindings/revoke_binding.dart';
import '../modules/revoke/views/revoke_view.dart';
import '../modules/sign/bindings/sign_binding.dart';
import '../modules/sign/views/sign_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN,
      page: () => SignView(),
      binding: SignBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATE,
      page: () => CertificateView(),
      binding: CertificateBinding(),
    ),
    GetPage(
      name: _Paths.DEVICE,
      page: () => ListDeviceView(),
      binding: ListDeviceBinding(),
    ),
    GetPage(
      name: _Paths.REVOKE,
      page: () => RevokeView(),
      binding: RevokeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_DEVICE,
      page: () => RegisterDeviceView(),
      binding: RegisterDeviceBinding(),
    ),
  ];
}
