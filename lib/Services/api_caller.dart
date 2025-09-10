import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:utshop/Global/constant.dart';
import 'package:utshop/Global/global_value.dart';
import 'package:utshop/Services/auth.dart';
import 'package:utshop/Utils/utils.dart';

class APICaller {
  static APICaller? _apiCaller = APICaller();
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static Duration timeout = const Duration(seconds: 30);
  static FutureOr<http.Response> Function()? onTimeout = () {
    return http.Response(
      'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
      408,
    );
  };

  static APICaller getInstance() {
    _apiCaller ??= APICaller();
    return _apiCaller!;
  }

  handleResponse(http.Response response) async {
    final body = jsonDecode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return body;
    } else {
      Utils.showSnackBar(
        title: "${response.statusCode}!",
        message: body['message'],
      );
      if (response.statusCode == 406) Auth.backLogin(true);
      return null;
    }
  }

  Future<dynamic> get(String endpoint, {dynamic body}) async {
    Uri uri = Uri.parse(_baseUrl + endpoint);
    String token = GlobalValue.getInstance().getToken();
    var frequestHeaders = {...requestHeaders, 'Authorization': token};
    var response = await http
        .get(uri, headers: frequestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      var refreshToken = await Utils.getStringValueWithKey(
        Constant.REFRESH_TOKEN,
      );
      Uri uriRF = Uri.parse('${_baseUrl}v1/auth/refresh-token');

      final data = await http
          .post(
            uriRF,
            headers: frequestHeaders,
            body: jsonEncode({"token": refreshToken}),
          )
          .timeout(timeout, onTimeout: onTimeout);

      if (data.statusCode ~/ 100 == 2) {
        final dataRF = jsonDecode(data.body);
        token = 'Bearer ${dataRF['data']['access_token']}';
        frequestHeaders['Authorization'] = token;
        GlobalValue.getInstance().setToken(token);
        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          dataRF['data']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          dataRF['data']['refresh_token'],
        );
      } else {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: "Có lỗi xảy ra chưa xác định!",
        );
      }
    }

    response = await http
        .get(uri, headers: frequestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    Uri uri = Uri.parse(_baseUrl + endpoint);
    String token = GlobalValue.getInstance().getToken();
    var frequestHeaders = {...requestHeaders, 'Authorization': token};
    var response = await http
        .post(uri, headers: frequestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      var refreshToken = await Utils.getStringValueWithKey(
        Constant.REFRESH_TOKEN,
      );
      Uri uriRF = Uri.parse('${_baseUrl}v1/auth/refresh-token');

      final data = await http
          .post(
            uriRF,
            headers: frequestHeaders,
            body: jsonEncode({"token": refreshToken}),
          )
          .timeout(timeout, onTimeout: onTimeout);

      if (data.statusCode ~/ 100 == 2) {
        final dataRF = jsonDecode(data.body);
        token = 'Bearer ${dataRF['data']['access_token']}';
        frequestHeaders['Authorization'] = token;
        GlobalValue.getInstance().setToken(token);
        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          dataRF['data']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          dataRF['data']['refresh_token'],
        );
      } else {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: "Có lỗi xảy ra chưa xác định!",
        );
      }
    }

    response = await http
        .post(uri, headers: frequestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    Uri uri = Uri.parse(_baseUrl + endpoint);
    String token = GlobalValue.getInstance().getToken();
    var frequestHeaders = {...requestHeaders, 'Authorization': token};
    var response = await http
        .put(uri, headers: frequestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      var refreshToken = await Utils.getStringValueWithKey(
        Constant.REFRESH_TOKEN,
      );
      Uri uriRF = Uri.parse('${_baseUrl}v1/auth/refresh-token');

      final data = await http
          .post(
            uriRF,
            headers: frequestHeaders,
            body: jsonEncode({"token": refreshToken}),
          )
          .timeout(timeout, onTimeout: onTimeout);

      if (data.statusCode ~/ 100 == 2) {
        final dataRF = jsonDecode(data.body);
        token = 'Bearer ${dataRF['data']['access_token']}';
        frequestHeaders['Authorization'] = token;
        GlobalValue.getInstance().setToken(token);
        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          dataRF['data']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          dataRF['data']['refresh_token'],
        );
      } else {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: "Có lỗi xảy ra chưa xác định!",
        );
      }
    }

    response = await http
        .put(uri, headers: frequestHeaders, body: jsonEncode(body))
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    Uri uri = Uri.parse(_baseUrl + endpoint);
    String token = GlobalValue.getInstance().getToken();
    var frequestHeaders = {...requestHeaders, 'Authorization': token};
    var response = await http
        .delete(uri, headers: frequestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      var refreshToken = await Utils.getStringValueWithKey(
        Constant.REFRESH_TOKEN,
      );
      Uri uriRF = Uri.parse('${_baseUrl}v1/auth/refresh-token');

      final data = await http
          .post(
            uriRF,
            headers: frequestHeaders,
            body: jsonEncode({"token": refreshToken}),
          )
          .timeout(timeout, onTimeout: onTimeout);

      if (data.statusCode ~/ 100 == 2) {
        final dataRF = jsonDecode(data.body);
        token = 'Bearer ${dataRF['data']['access_token']}';
        frequestHeaders['Authorization'] = token;
        GlobalValue.getInstance().setToken(token);
        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          dataRF['data']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          dataRF['data']['refresh_token'],
        );
      } else {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: "Có lỗi xảy ra chưa xác định!",
        );
      }
    }

    response = await http
        .delete(uri, headers: frequestHeaders)
        .timeout(timeout, onTimeout: onTimeout);

    return handleResponse(response);
  }

  Future<dynamic> postFile({required File file}) async {
    Uri uri = Uri.parse("${_baseUrl}v1/file/single-upload");
    String token = GlobalValue.getInstance().getToken();
    var frequestHeaders = {...requestHeaders, 'Authorization': token};

    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    // request.fields['Type'] = type;
    request.headers.addAll(frequestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response('Không kết nối được đến máy chủ', 408);
      },
    );

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      var refreshToken = await Utils.getStringValueWithKey(
        Constant.REFRESH_TOKEN,
      );
      Uri uriRF = Uri.parse('${_baseUrl}v1/auth/refresh-token');

      final data = await http
          .post(
            uriRF,
            headers: frequestHeaders,
            body: jsonEncode({"token": refreshToken}),
          )
          .timeout(timeout, onTimeout: onTimeout);

      if (data.statusCode ~/ 100 == 2) {
        final dataRF = jsonDecode(data.body);
        token = 'Bearer ${dataRF['data']['access_token']}';
        frequestHeaders['Authorization'] = token;
        GlobalValue.getInstance().setToken(token);
        Utils.saveStringWithKey(
          Constant.ACCESS_TOKEN,
          dataRF['data']['access_token'],
        );
        Utils.saveStringWithKey(
          Constant.REFRESH_TOKEN,
          dataRF['data']['refresh_token'],
        );
      } else {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: "Có lỗi xảy ra chưa xác định!",
        );
      }
    }

    streamedResponse = await request.send();
    response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response('Không kết nối được đến máy chủ', 408);
      },
    );

    return handleResponse(response);
  }
}
