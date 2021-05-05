import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:movie_api/service/config/custom_interceptions.dart';

class CustomDio extends DioForNative {
  CustomDio() {
    options.connectTimeout = 60000;
    interceptors.add(CustomInterceptors(Dio()));
  }
}
