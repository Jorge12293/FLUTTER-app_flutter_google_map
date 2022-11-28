import 'package:app_flutter_map/data/key.dart';
import 'package:dio/dio.dart';


class TrafficInterceptor  extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.queryParameters.addAll({
      'alternatives':false,
      'geometries':'polyline6',
      'overview':'simplified',
      'steps':false,
      'access_token':accessToken
    });

    super.onRequest(options, handler);
  }

}