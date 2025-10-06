part of 'app_page.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const introduce = _Paths.introduce;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const verifyRegister = _Paths.verifyRegister;
  static const forgotPassword = _Paths.forgotPassword;
  static const verifyForgotPassword = _Paths.verifyForgotPassword;
  static const resetPassword = _Paths.resetPassword;
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const popularProduct = _Paths.popularProduct;
  static const allProduct = _Paths.allProduct;
  static const productDetail = _Paths.productDetail;
  static const wishlish = _Paths.wishlish;
  static const cart = _Paths.cart;
  static const confirmOrder = _Paths.confirmOrder;
  static const profile = _Paths.profile;
  static const info = _Paths.info;
  static const orderHistory = _Paths.orderHistory;
  static const detailOrderHistory = _Paths.detailOrderHistory;
  static const deliveryAddress = _Paths.deliveryAddress;
  static const voucher = _Paths.voucher;
  static const changePassword = _Paths.changePassword;
}

abstract class _Paths {
  _Paths._();
  static const String splash = '/splash';
  static const String introduce = '/introduce';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyRegister = '/verify-register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyForgotPassword = '/verify-forgot-password';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String popularProduct = '/popular-product';
  static const String productDetail = '/product-detail';
  static const String allProduct = '/all-product';
  static const String wishlish = '/wishlish';
  static const String cart = '/cart';
  static const String confirmOrder = '/confirm-order';
  static const String profile = '/profile';
  static const String info = '/info';
  static const String orderHistory = '/order-history';
  static const String detailOrderHistory = '/detail-order-history';
  static const String deliveryAddress = '/delivery-address';
  static const String voucher = '/voucher';
  static const String changePassword = '/change-password';
}
