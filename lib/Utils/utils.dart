import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  // static final String _baseUrl = dotenv.env['API_URL'] ?? '';

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future getBoolValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future saveBoolWithKey(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static String formatVndCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      name: ' ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String formatDate({String? isoString, bool isDateOnly = false}) {
    if (isoString == null || isoString.trim().isEmpty) {
      return "--";
    }

    try {
      DateTime dateTime = DateTime.parse(isoString);
      if (isDateOnly) {
        return DateFormat('dd/MM/yyyy').format(dateTime);
      } else {
        return DateFormat('HH:mm - dd/MM/yyyy').format(dateTime);
      }
    } catch (e) {
      return "--";
    }
  }

  static getImagePicker(int source) async {
    ImagePicker picker = ImagePicker();
    File? file;
    try {
      await picker
          .pickImage(
            source: source == 1 ? ImageSource.camera : ImageSource.gallery,
          )
          .then((value) {
            if (value != null) {
              file = File(value.path);
            }
          });
    } catch (e) {
      return null;
    }
    return file;
  }

  static Future<File?> getFilePicker() async {
    File? file;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // hoặc FileType.image, FileType.custom, ...
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        file = File(result.files.single.path!);
      }
    } catch (e) {
      return null;
    }
    return file;
  }

  static void showSnackBar({
    required String title,
    required String message,
    Color? colorText = Colors.white,
    Widget? icon,
    bool isDismissible = true,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 300),
    Color backgroundColor = Colors.black,
    int opacityBackground = 204,
    SnackPosition? direction = SnackPosition.TOP,
    Curve? animation,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor.withAlpha(opacityBackground),
      snackPosition: direction,
      forwardAnimationCurve: animation,
      isDismissible: isDismissible,
    );
  }

  static showDateTimePicker({
    required BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
    Locale locale = const Locale('vi', 'VN'),
    required Function(DateTime?) onValue,
    Function? onError,
  }) {
    firstDate ??= DateTime(2000);
    lastDate ??= DateTime.now();

    showDatePicker(
      context: context,
      locale: locale,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then(onValue, onError: onError);
  }
}
