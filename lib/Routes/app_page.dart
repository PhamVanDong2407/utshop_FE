import 'package:get/get.dart';
import 'package:utshop/Views/Cart/cart.dart';
import 'package:utshop/Views/ForgotPassword/forgot_password.dart';
import 'package:utshop/Views/ForgotPassword/reset_password.dart';
import 'package:utshop/Views/ForgotPassword/verify_forgot_password.dart';
import 'package:utshop/Views/Home/AllProduct/all_product.dart';
import 'package:utshop/Views/Home/PopularProduct/popular_product.dart';
import 'package:utshop/Views/Home/ProductDetail/product_detail.dart';
import 'package:utshop/Views/Home/home.dart';
import 'package:utshop/Views/Login/login.dart';
import 'package:utshop/Views/Profile/ChangePassword/change_password.dart';
import 'package:utshop/Views/Profile/DeliveryAddress/delivery_address.dart';
import 'package:utshop/Views/Profile/Info/info.dart';
import 'package:utshop/Views/Profile/OrderHistory/DetailOrderHistory/detail_order_history.dart';
import 'package:utshop/Views/Profile/OrderHistory/order_history.dart';
import 'package:utshop/Views/Profile/profile.dart';
import 'package:utshop/Views/Register/register.dart';
import 'package:utshop/Views/Register/verify_register.dart';
import 'package:utshop/Views/Wishlist/wishlish.dart';
import 'package:utshop/Views/dashboard.dart';
import 'package:utshop/Views/introduce.dart';
import 'package:utshop/Views/splash.dart';

part 'app_route.dart';

class AppPage {
  AppPage._();

  static const String initialRoute = Routes.splash;

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: Routes.splash, page: () => Splash()),
    GetPage(name: Routes.introduce, page: () => IntroductionScreen()),
    GetPage(name: Routes.login, page: () => Login()),
    GetPage(name: Routes.register, page: () => Register()),
    GetPage(name: Routes.verifyRegister, page: () => VerifyRegister()),
    GetPage(name: Routes.forgotPassword, page: () => ForgotPassword()),
    GetPage(name: Routes.verifyForgotPassword, page: () => VerifyForgotPassword()),
    GetPage(name: Routes.resetPassword, page: () => ResetPassword()),
    GetPage(name: Routes.dashboard, page: () => Dashboard()),
    GetPage(name: Routes.home, page: () => Home()),
    GetPage(name: Routes.popularProduct, page: () => PopularProduct()),
    GetPage(name: Routes.allProduct, page: () => AllProduct()),
    GetPage(name: Routes.productDetail, page: () => ProductDetail()),
    GetPage(name: Routes.wishlish, page: () => Wishlish()),
    GetPage(name: Routes.cart, page: () => Cart()),
    GetPage(name: Routes.profile, page: () => Profile()),
    GetPage(name: Routes.info, page: () => Info()),
    GetPage(name: Routes.orderHistory, page: () => OrderHistory()),
    GetPage(name: Routes.detailOrderHistory, page: () => DetailOrderHistory()),
    GetPage(name: Routes.deliveryAddress, page: () => DeliveryAddress()),
    GetPage(name: Routes.changePassword, page: () => ChangePassword()),
  ];
}
