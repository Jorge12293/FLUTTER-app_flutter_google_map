import 'package:app_flutter_map/data/key.dart';
import 'package:dio/dio.dart';



class PlacesInterceptor extends Interceptor {
  

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
    });


    super.onRequest(options, handler);
  }

}