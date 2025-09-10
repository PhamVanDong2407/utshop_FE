import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (_, child) => GetMaterialApp(
            title: 'UTShop',
            theme: ThemeData(
              primaryColor: AppColor.primary,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColor.primary,
                selectionColor: AppColor.primary,
                selectionHandleColor: AppColor.primary,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                titleSpacing: 20,
                elevation: 0,
                foregroundColor: AppColor.text1,
                backgroundColor: AppColor.main,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: AppColor.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: AppPage.initialRoute,
            getPages: AppPage.routes,
          ),
    );
  }
}
